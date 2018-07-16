---
title: "Modeling a Rubik's Cube"
date: 2018-07-16T13:00:02+03:00
draft: true
---

There are a couple of programming problems I've thought about since I was a teen, but never made a real effort to solve. One of them is solving the Rubik's Cube.

A couple of weeks ago my kids got a 2x2x2 cube each as a present, and after solving it manually I decided it's probably easy enough to solve in software too. So this time I at least started to work on it.
<!-- more -->

I haven't yet worked on a solver, but I found just modeling the cube an interesting problem. There are plenty of possible approaches. Some are probably documented elsewhere and of course I could look at what existing open source solvers do, but I made it a point to first find a workable approach on my own.

Even though I'm planning to solve a 2x2 cube first, I'm already thinking of how the standard 3x3 cube could be modeled. I'll be mostly discussing 3x3 here.

## How naive can you get?

A very naive approach, similar to how many first-timers approach the cube, would be to just note what stickers are visible on each face. That is, have a 3x3 table of colors for each face (a cube has six faces). Using such a mental model the best you can do tends to be getting one face with all stickers the same color (but *not* a solved layer). I expect working in code to be as tedious as mentally, given such a data structure.

The next step to understanding the cube is to realize it consists of pieces. You can think of these pieces as small cubes. 3x3x3 = 27 of them. The small cubes have different amounts of stickers fixed on them. You could save each small cube's position, what stickers it has, and how it is oriented.

But you're much better off when you consider the cube has two types of moving pieces: corners and edges. The centers are fixed in relation to each other. I'm pretty sure you can't solve the cube until you apprehend this.

## Minimizing redundancy

The 3x3 cube has 4.3e19 permutations (according to Wikipedia). That's 66 bits of information. A reasonable representation probably uses some more than that, but that's something to keep in mind.

A simple model is to consider that corners can be only in corner positions and edges in edge positions, and each corner position has three possible orientations while edge positions have two. So a corner can be in 8 different places in 3 orientations, ie. 24 possibilities. An edge has 12 possible positions with 2 orientations so it also has 24 possibilities. We could basically use 5 bits per piece, for 20 pieces, and get a representation of the whole cube in 100 bits. That's quite a bit more than 66 bits, but considering we already waste 5 bits for 24 alternatives and not all cube positions are possible, that's quite efficient.

Such a simple model sounds nice, but after playing around with the idea for a bit I was disappointed. It's easy to just number the positions, but what's a smart way to number the orientations? Consider you use a couple of twists to get a corner piece to the opposite corner of the cube. What's its orientation? Which set of twists keeps orientation? It seems to me that using an orientation-enumerating system requires you to basically have a lookup table for rotations.[^1] That's not beautiful enough for me. Please prove me wrong, though.

## What about using only the orientation?

An insight I got was that position is actually redundant information if you consider the full 3D orientation of each piece. There's only one position where a corner can have its faces up, left and front. Same goes for edge pieces. [^2]

Again I had the question of how the orientations can be represented. I considered using quaternions or rotation matrices, which would definitely work but make computations very heavy. I thought about using the possible axes and Euler angles, but that has the same problems as just enumerating the orientations. The axes aren't in right angles, either, which might not be an issue but at least seems weird.

I tried to come up with a simple formalism limited only to right-angle rotations. The one I settled on eventually is simple, alright:

```clojure
(def solved-3x3
  [[:u :f :l] [:u :l :b] [:u :b :r] [:u :r :f]              ; corners - top
   [:d :f :l] [:d :l :b] [:d :b :r] [:d :r :f]              ; corners - bottom
   [:u :f] [:u :l] [:u :b] [:u :r]                          ; edges - top
   [:f :l] [:l :b] [:b :r] [:r :f]                          ; edges - middle
   [:d :f] [:d :l] [:d :b] [:d :r]])                        ; edges - bottom
```

That's my first iteration of Clojure code representing the 3x3 cube in its solved state. A single corner, for instance, is written like `[:u :f :l]` meaning its stickers are facing up, front and left.

It's not perfect, but it has many characteristics I like:

- There is only the canonical representation for each state.
- Rotations on different faces can use the same implementation. No special cases.
- Rotations for corners and edges can use the same implementation!
- The notation is sort-of familiar to someone who knows cubing notation.

There are downsides, too:

- The ordering and orientation of the pieces is arbitrary and relative. You just need to know the solved state and use the same notation for other states.
- The implementation as Clojure vectors and keywords is probably not efficient.
- There is redundancy, even if we could narrow it down to six alternatives per keyword and save it as 3 bits. That's 144 bits total. Corners could be unambiguously described as the main face (6 alternatives) and the secondary face (4 alternatives), which I don't make use of here.

## Implementing rotations

I mentioned that the same rotation implementation works for every face, both for edges and corners. [The code is online](https://github.com/dancek/ruebik), but I'll describe the general approach.

A rotation affects the pieces on the face you're rotating. For example, *U* (rotating the upper face clockwise, in cubing notation) affects every piece that contains `:u`.

The orientation of the affected pieces changes predictably. For *U*, the cycle is f-l-b-r-f-l-b-r-... meaning that what was on the front face will be on the left face, etc. So our example corner piece `[:u :f :l]` gets transformed to `[:u :l :b]` in the *U* rotation.

What's better, you can get all these cycles from a single list of faces with a bit of tricks. Took me a couple of tries to figure it out.

```clojure
(def fwd-ring [:u :f :l :d :b :r])
```

When you take this sequence and remove both the face you're twisting on and the opposite face, you have the correct cycle. Even and odd positions vary in direction; reverse to get the other direction, obviously. I have a function called `ring-for-face` that does just that.

It's useful to have a mapping instead of just the cycle. Then you can just map all the faces of all the affected pieces using the mapping, and the rotation is complete.

Creating mappings like that is quite easy given the aforementioned `fwd-ring` and `ring-for-face`:

```clojure
(defn rotations-for-face
  [face]
  (let [ring         (ring-for-face face)
        same-map     (zipmap fwd-ring fwd-ring)
        rotation-map (zipmap ring (rest (cycle ring)))]
    (merge same-map rotation-map)))
```

```clojure
(rotations-for-face :u)
=> {:u :u, :f :l, :l :b, :d :d, :b :r, :r :f}
```

It took about 30 lines of code to implement rotations around this idea. I suspect some of [my current code](https://github.com/dancek/ruebik/blob/17c59cccda53c5a5cc8f8862ddf791a5987d5dbf/src/ruebik/core.clj) is unidiomatic and verbose. I'm not very experienced with lisps, let alone Clojure.

## My thoughts

It took me quite a bit of effort to find a good data structure for modeling a Rubik's Cube. But I'm much further than all the previous times I considered this problem. There certainly are more efficient approaches, and probably also more beautiful ones, but this is a start.

Finding a solution is going to be a lot more work. I suspect that for 2x2 a breadth-first search is possible, but for the 3x3 it's unreasonable to even try finding the shortest solution. I think I'll try to work with some heuristic and A* search or something, but it will probably be hard to find a heuristic where you don't have to go back to a worse value for multiple moves even for the optimal solution. There will surely be a lot to learn.

[^1]: My reasoning: each rotation should change the position and orientation using a simple formula. Doing the same rotation four times returns the cube to its original position. There are three possible orientations for a corner, so the only constant a rotation can add to orientation is 0. Sounds like a lookup table.

[^2]: A caveat is that this only works for cubes up to 3x3. I own a 4x4 and have a hard time solving when there's wrong parity... But I refuse to worry about that now.
