+++
title = "Clojure in Google Cloud Run with Jib"
date = 2020-06-01
+++

[Cloud Run](https://cloud.google.com/run/) is a managed serverless platform for containerized applications in Google Cloud. Very similar to AWS Lambda, that is.

Cloud Run has documentation for [containerizing and deploying Java applications with Jib](https://cloud.google.com/java/getting-started/jib). That makes building and deploying both very fast and very easy, while not requiring deep knowledge of Docker internals and best practices. Since Clojure is a JVM language, Jib is also suitable for it.


## Minimal Leiningen project

Leiningen is based on Maven, and Jib has a first-class Maven plugin. That makes it the easiest choice of Clojure build tools for running Jib.

Note: replace `my-gcp-project` with an actual GCP project you control.

```clojure
;; project.clj
(defproject my-app "0.1.0-SNAPSHOT"
  :main ^:skip-aot my-app.main

  :pom-plugins
  [[com.google.cloud.tools/jib-maven-plugin "2.1.0"
    (:configuration
      [:from [:image "gcr.io/distroless/java:11"]]
      [:to [:image "gcr.io/my-gcp-project/my-app"]]
      [:container
       [:mainClass "my-app.main"]
       [:creationTime "USE_CURRENT_TIMESTAMP"]])]]

  :dependencies
  [[org.clojure/clojure "1.10.1"]
   [ring/ring-core "1.8.1"]
   [ring/ring-jetty-adapter "1.8.1"]])
```


## Simple application

Cloud Run requires that applications run an http server on the port `PORT` (from environment variable). The easiest way to do that is with `ring.adapter.jetty`.

```clojure
;; src/my_app/main.clj
(ns my-app.main
  (:gen-class)
  (:require [ring.adapter.jetty :refer [run-jetty]]))

(defn- handler
  [_req]
  {:status 200
   :body   "Hello world!"})

(defn serve
  [port]
  (run-jetty
    handler
    {:host  "0.0.0.0"
     :port  port
     ;; run-jetty takes over the thread by default, which is bad in a REPL
     :join? false}))

(defn -main
  [& _args]
  (serve (Long/parseLong (System/getenv "PORT"))))
```


## Running locally

Locally, the app can be run with `PORT=3000 lein run`. Or for a REPL, run `lein repl` and start the server with `(serve 3000)`.

The server answers as expected:

```sh
$ http localhost:3000
HTTP/1.1 200 OK
Content-Length: 12
Date: Fri, 22 May 2020 09:15:17 GMT
Server: Jetty(9.4.28.v20200408)

Hello world!
```


## Deploying

Building and deploying happens in three steps. You will need to have the `gcloud` CLI tools and be logged in.

```sh
# 1. Compile the code and generate a pom.xml
lein do compile :all, pom

# 2. Containerize with Jib and upload the container to registry
mvn compile jib:build

# 3. Deploy from registry to Cloud Run
gcloud config set project my-gcp-project  # or set CLOUDSDK_CORE_PROJECT
gcloud run deploy --image gcr.io/my-gcp-project/my-app
```

Voilà! The `gcloud run deploy` command will inform you of the app's endpoint and the endpoint answers Hello world!


## Alternatives

There are obviously many other possible ways for creating a Docker container that runs Clojure and exposes an HTTP server. The main upside of Jib is fast builds and uploads with best practices and maintenance (I believe, but I've been wrong before). DIY Dockerfile based approaches are an alternative, but not a very inviting one.

Where a custom container might shine, though, is with GraalVM. Building the application as a single-binary container might lower both startup time and memory consumption. But at the moment, Jib seems a safer choice for production use.

Another point of contention might be the use of Leiningen. In this example we technically use `lein` and `mvn` in separate passes, so you could get similar results with another build tool and a hand-written `pom.xml`. This is just a bit quicker to set up. A realistically better option might be to use Jib without Maven, but there's no mature tooling for that. Once [jib-cli](https://github.com/GoogleContainerTools/jib/tree/master/jib-cli) becomes stable, it's probably the better choice.
