---
date: 2023-06-06 09:00:00+02:00
tags:
  - configuration
  - simplesamlphp
  - technical
title: Theme generator for SimpleSAMLphp
---

> This theme generator has been updated for SimpleSAMLphp 2.0.x
{.message-box .info}

A number of people seem to find [SimpleSAMLphp's theming system](https://simplesamlphp.org/docs/stable/simplesamlphp-theming)
intimidating. To aid with this, we've written a simple [theme generator](/wp-content/uploads/2023/06/ssp-theme-generator.sh) for SimpleSAMLphp.

The generator takes SSP's [stock templates](https://github.com/simplesamlphp/simplesamlphp/tree/master/templates)
and massages them to include some branding -- amongst other things, a logo on the top left of the page and
corporate colours in the header bar.

The generator is a bash script, and is [available here](/wp-content/uploads/2023/06/ssp-theme-generator.sh).
It takes a number of command line options which can be used to manipulate the resulting theme:

```
Usage: ssp-theme-generator.sh -n <name> [...]
 -n <name>  organisation's display name
 -c <col>   main corporate colour as HTML hex value [default: #060606]
 -l <uri>   full path or URL to logo [default: none]
 -u <url>   home page URL

 -t <name>  theme name [default: $(hostname -s)]
 -i <uri>   full path or URL to favicon [default: <homepageUrl>/favicon.ico]
 -C <col>   complementary colour as HTML hex value [default: calculated]

 -s <url>   support website link
 -S <text>  support link text [default: Help & Support]
 -p <url>   privacy statement link
 -P <text>  privacy link text [default: Privacy statement]

 -b <dir>   the base directory of SimpleSAMLphp [default: .]
 -d <dir>   module output directory [default: <sspbase>/modules]
 -f         force overwriting
 -L         copy logo if remote (needs -l with a uri)
 -v         verbose output
 -V         output version number

This program needs GNU sed (and optionally bc and one of {wget,curl,fetch})
```

The resulting theme can either be used as-is, or as a point of departure for generating your own theme.

## Output

The script generates a module (by default, preinstalled in SimpleSAMLphp's `modules/` directory as `modules/_themename_`).

The module consists of some basic header and footer templates in `_themename_/themes/_themename_/default` and some CSS in `_themename_/public/assets/css/_themename_.css`. The CSS is commented to give some idea of how it can be tweaked to better suit your needs.

Both the `-l` and `-i` options can take either a full path to a local file or a URL. In both cases, if a path is give, it's copied into the theme's `public/assets/icons` directory. If a URL is given for the logo, it's served from that location unless `-L` is given; if one is given for a favicon, it's fetched and saved in `public/assets/icons/`.

## Screenshots

The following screenshots from desktop and mobile browsers give some idea of the result:

[{{< figure src="/wp-content/uploads/2023/06/ssp-theme-generator-desktop.png" caption="Generated theme on desktop" >}}](/wp-content/uploads/2023/06/ssp-theme-generator-desktop.png)

[{{< figure src="/wp-content/uploads/2023/06/ssp-theme-generator-mobile.png" caption="Generated theme on mobile" >}}](/wp-content/uploads/2023/06/ssp-theme-generator-mobile.png)

## Requirements

The script is written in the bash shell. It requires GNU sed and will attempt to find this as both `sed` (for Linux systems) and `gsed` (for BSD) systems. It can optionally use `bc` to do some colour maths, but will use an alternative pure-bash strategy if this is not available.

The current version (20230601) of the script has been tested against SimpleSAMLphp v2.0.4. An older version (developed for 1.18.x) is [still available](/wp-content/uploads/2018/08/ssp-theme-generator.sh).
