# Vibe.d web framework

[Vibe.d](http://vibed.org) is a very powerful web
framework which, for example, underlies this D language tour website.
Here are some of vibe.d's highlights:

* Based on a fiber based approach for *asynchronous I/O*
  vibe.d allows you to write high-performance HTTP(S) web servers
  and web services. You can write code that looks synchronous
  but which can actually handle
  thousands of connections asynchronously in the background!
  See the next section for a complete example.
* Provides an easy to use JSON and web interface generator.
* Has out-of-the-box
  support for Redis and MongoDB that makes it easy to
  write backend systems that have good performance.
* Can be used to create generic TCP or UDP clients and servers.

Note that the examples in this chapter
can't be run online because they
would require network support which is disabled
for obvious security reasons.

The easiest way to create a vibe.d project is to install
`dub` and create a new project with *vibe.d* specified
as template:

    dub init <project-name> -t vibe.d
    cd <project-name>
    dub

`dub` will make sure that vibe.d is downloaded and
available for building your vibe.d based project.

The book [D Web development](https://www.packtpub.com/web-development/d-web-development)
gives a thorough introduction into this excellent framework.
