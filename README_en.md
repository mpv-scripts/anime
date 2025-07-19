# What is this?

This is a script for mpv player, allowing you to watch videos from various dubbers sites (like pvashow or animy) or pirate cinemas like amedia.online or so on, right in `mpv`, instead of browser.

# How to install?

Clone this repo to `~/.config/mpv/scripts` (on Linux, or corresponding path to scripts directory for other OS'es, that uses another paths)

(currently, no distributions provide system-wide packages, and most probably never will)

# How to use?

```
## Amedia:

$ mpv https://amedia.online/<title_name>/episode/<episode_number>/seriya-onlayn.html
```

At the time of writing this, I've only implemented playing per-episode (using links to the episodes).
But I have plans to support full-title-links (and fill playlist)


If you want to choose another (than "auto") resolution (most of the time there is only 1080p and 360p available in addition to 720p, so for now plugin only supports them), you can declare that by adding `###q=<res>` (where `<res` is the resolution you need) to the end of link

```
$ mpv 'https://<.......>.html###q=1080p'
$ mpv 'https://<.......>.html###q=720p'
$ mpv 'https://<.......>.html###q=360p'

```

## pvashow
In case of pvashow, you shall pass the whole season page (and it will be converted to playlist).
It is possible to choose an episode to start play with, although, selection will be based on it's position in the
playlist, and not titled number (so, it can misbehave with your expectations because of releasers actions)

# animy/ruchime

In case of animy, there is very hard usage scheme, and many issues.
As result of my struggling of trying to work with their site, and struggling of watching their releases, it is very hard
to me to not call them morons. All of them: site admins, programmers, translators and voice actors.

As I started to avoid animy (reborn as ruchime) releases anywhere and anyhow as possible, you may count scripts for
their site as "mainainer needed" status, as it is very unlikely that I will notice and/or fix something broken there.

(also, they're heavily use fucking kodik, so many titles anyway will not work)
