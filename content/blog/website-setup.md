---
title: "Decentralize – Website setup is easy"
date: 2018-04-10T08:44:25+03:00
tags: ["hugo", "netlify", "web", "decentralization"]
---

*The web has become very centralized, with people mostly creating content in social media. While this enables publishing without any technical skills, there are many downsides. Meanwhile, creating and publishing your own website has become easier than ever. In this post, I'll show an easy way to create a modern static site for free.*
<!--more-->

I've set up half a dozen personal websites, most of which never saw much content. Mostly I got stuck with fine-tuning some technical details and never got around to writing content. I've also experimented with social media and centralized platforms---my cooking blog is still out there, I have written thousands of unworthwhile comments in various places and probably even made some useful contributions on StackExchange sites.

I've also worked on a dozen websites professionally. Commercial websites (and web apps) tend to have very different goals and requirements, though.

What are my requirements and goals for a platform where I publish my content, then?

1. The content must be **accessible** to other people.
2. ‎The content must be **durable**. I should have backups of the data.
3. ‎I should have **ownership** to the content. I want to be able to edit it, move it, keep it, whatever. I should have the intellectual property rights.
4. ‎Creating and publishing content must be **easy**.
5. ‎Content should be relatively **free-form**. I know I'm going to have text, headings, lists, images and code snippets---if I have my way.

And this is part of the reason I'm unhappy with posting to a platform like Facebook. Publishing there is very easy and the content is accessible enough, but the rest of those points aren't fulfilled. In addition, Facebook (and any similar platform) raises ethical and privacy concerns. What will they do with my data? Am I part of the reason other people also have to use that platform? How do their content selection algorithms affect people's opinions and the society as a whole? We already talked about agenda setting in the age of TV and newspapers---yet they are ridiculously inefficient in targeting and steering people compared to the technologies social media platforms have at their disposal. Ironic, then, that I'm planning to post a link to this post on Facebook...

I haven't yet made a convincing argument that a personal website is any better. Like I said, I've had multiple, and I've failed each of my requirements on at least one of them. Thankfully times change and what used to be very cumbersome to get working is now very simple. Let me show you.

## Hugo

Enter [Hugo, a modern static site generator](https://gohugo.io). I've always loved static sites: if the visitor of the site is going to get HTML and CSS anyway, why should the server run a huge and slow piece of software that generates the pages per request. Or in the modern world of single page apps: if the visitor is just going to read some text and look at some pictures, why should a huge complicated blob of JavaScript generate it on the fly.

I've had several static sites before, starting with hand-written HTML, trying Jekyll back when it was cool, all the way to rolling my own system with Docpad and self-written templates and some git hooks. It's always worked, but it never was easy enough when it was time to write something. It is now.

Installing Hugo from a package manager is easy:

```
$ brew install hugo
```

So is [creating a new site](https://gohugo.io/getting-started/quick-start/):

```
$ hugo new site hannuhartikainen.fi
```

Obviously I want version control, so

```
$ cd hannuhartikainen.fi
$ git init
```

At that point it's time to choose one of the available [Hugo themes](https://themes.gohugo.io/). Adding the theme is easy, too. For example:

```
$ git submodule add https://github.com/MunifTanjim/minimo themes/minimo
$ git submodule init
$ git submodule update
```

The only thing still needed is configuration, ie. a `config.toml` file. It allows a lot of customization of both Hugo internals and of the selected theme, so a good place to start is the documentation for the theme. A minimal example would be something like:

```toml
baseURL = "https://hannuhartikainen.fi/"
title = "My personal website"
theme = "minimo"
```

You can see what the site looks like by running a local server. The server tells you where it's serving the content, eg. http://localhost:1313/.
(The `-D` option shows draft content. It will be useful later when you have unfinished content and you want to see it on your local server.)

```
$ hugo server -D
```

There. It works. Time for a commit. [My initial commit for this website](https://github.com/dancek/hannuhartikainen.fi/commit/717a2cd947fdd18e35bb700c7017a71626bb615a) was relatively small but got the site up and running.

Adding content is easy, too.

```
$ hugo new blog/first-post.md
```

Then write something in `blog/first-post.md` (formatting in [Markdown](https://en.wikipedia.org/wiki/Markdown)). [My second commit](https://github.com/dancek/hannuhartikainen.fi/commit/5347fc0f6d1583c7d356ed08e7c004406d87b1c6) was very simple: it only contained one new file, yet the new blog post appeared online. But we're getting ahead of ourselves: online? Don't you need hosting for that?

## Netlify

You could host static sites anywhere and that's part of the appeal for me. But I'm so happy with [Netlify](https://www.netlify.com/) I wouldn't recommend anything else (as long as they cost nothing, etc).

So once you have a Hugo site in a git repo, you need to push it to Github, Gitlab or Bitbucket. That's what Netlify currently supports. Then getting the site online is very easy. [Hugo also has docs for hosting on Netlify](https://gohugo.io/hosting-and-deployment/hosting-on-netlify/), which might be more up to date.

1. Create a Netlify account. Log in.
2. Create a new site. Select your repo.
3. Set deploy command: `hugo`.
4. Set publish directory: `public`.
5. Set an environment variable to get a more recent Hugo version: `HUGO_VERSION` = `0.38` (or something recent).

Netlify gives you a netlify.com subdomain and you should now be able to see your site online. Whenever you push updates to git, the site updates (usually in around 15 seconds in my experience). **Beautiful.**

You can also use a custom domain. It's very simple to set as long as you can configure your DNS records, just see [Netlify documentation on custom domains](https://www.netlify.com/docs/custom-domains/). I use [CloudFlare](https://www.cloudflare.com/) for DNS (which they offer for free).

HTTPS is also available and takes about one click to set up (using a Let's Encrypt cert). It's useful to add a file `static/_redirects` to redirect all HTTP traffic to HTTPS (again, see [Netlify docs on redirects](https://www.netlify.com/docs/redirects/)). Example:

```
http://hannuhartikainen.fi/* https://hannuhartikainen.fi/:splat 301!
```

## Summary

You can get a website up and running in half an hour using a piece of free software (Hugo; Apache License 2.0) and a bunch of services that cost nothing (Github, Netlify, CloudFlare). In my setup, the only thing that costs something is my domain. I have everything needed to do whatever I want with my website both in terms of content (I didn't go to Hugo internals, but it makes a lot of things possible) and platforms (there are alternatives to Github and Netlify, or you could host both git and http yourself).

### Recap: my requirements

I wanted my content to be **accessible**. It is from a technical point of view, and I think it is from an accessibility point of view (that's pretty much up to the theme). Anyone with a browser can see this page, no login required. There's even an RSS feed, out of the box.

I wanted my content to be **durable**. I'm trusting Netlify on hosting, but if there were any problems I could easily spin up the same HTML anywhere. I have backups, I have the data.

I wanted to have **ownership**. The content is mine. I didn't sign an EULA or accept a TOS before posting it.

I wanted everything to be **easy**. After the set up, it is. I type in my text editor just like any time I'm doing anything worthwhile. I commit and push and it's online.

I wanted the content to be **free-form**. Everything that Markdown supports is easy (and Hugo has some extensions to it), everything else is possible. I can write as short or as long posts as I want, and I can create whatever content structures I want (I'll probably add a page or two at some point).


### My thoughts

The setup is great.

I had plenty to rant about web technologies, social media, society and what have you, which I skipped. Even without that this post is probably too long for most people to read.

This post came dangerously close to blogging about blogging. I'll have to be careful about that.
