#!/usr/bin/env bash
#
# Bash script to generate a simple SSP theme based on the default template
#
# @author Guy Halse http://orcid.org/0000-0002-9388-8592
#
VERSION=20230725

usage()
{
echo "$(basename $0) version ${VERSION}

Usage: $(basename $0) -n <name> [...]
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
" >&2
    exit
}

#
# This function produces a complementary colour.  If bc is available, we
# produces the analogous colour from an HSL colour wheel.  If not, we
# produce the rough complement by hex maths in bash.  We could almost
# certainly do without having it here and just used a fixed, darker colour
# like #7c7c7c.  But it was fun to write :-)
#
complement()
{
    # get the decimal version of RGB space, taking cogniscence of shorthand notation.
    hex=${1#'#'}
    if test ${#hex} -eq 3 ; then
        r=$((16#${hex:0:1}${hex:0:1})); g=$((16#${hex:1:1}${hex:1:1})); b=$((16#${hex:2:1}${hex:2:1}))
    else
        r=$((16#${hex:0:2})); g=$((16#${hex:2:2})); b=$((16#${hex:3:2}))
    fi
    a=${2:-"30"}; a=${a#+}

    if test -x $(command -v bc) ; then
        bc -q << EOF
            /* Convert from RGB to HSL space, using the formulas from
             * http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/ */
            scale=5
            r = ${r}; g = ${g}; b = ${b}; a=${a}
            rf = r/255; gf = g/255; bf = b/255
            if (rf < gf) min = rf else min = gf
            if (bf < min) min = bf
            if (rf > gf) max = rf else max = gf
            if (bf > max) max = bf
            luminace = (max + min) / 2
            if (min == max) {
                saturation = 0; hue = 0
            } else {
                if (luminace < 0.5) {
                    saturation = (max-min)/(max+min)
                } else {
                    saturation = ( max-min)/(2.0-max-min)
                }
                if (rf == max) hue = (gf-bf)/(max-min)
                if (gf == max) hue = 2.0 + (bf-rf)/(max-min)
                if (bf == max) hue = 4.0 + (rf-gf)/(max-min)
            }
            hue *= 60
            saturation *= 100; luminace *= 100
            /* we have HSL */
            /* analogous complement */
            hue += a
            if (hue < 0) hue += 360
            if (hue > 360) hue -= 360
            /* going back to RGB space is a lot of maths, and browsers understand HSL, so ... */
            print "hsl(", hue, ", ", saturation, "%, ", luminace, "%)"
EOF
    else
        # hacky way of getting a complement
        printf '#%02x%02x%02x' $((16#ff - $r)) $((16#ff - $g)) $((16#ff - $b))
    fi
}

fetch()
{
    test $VERBOSE -ge 1 && echo -n "+ attempting to fetch $(basename ${2}) from ${1} using " >&2
    if test -x "$(command -v wget)"; then
        test $VERBOSE -ge 1 && echo wget
        wget -q -O "${2}" "${1}"
    elif test -x "$(command -v curl)"; then
        test $VERBOSE -ge 1 && echo curl
        curl -s "${1}" -o "${2}"
    elif test -x "$(command -v fetch)"; then
        test $VERBOSE -ge 1 && echo fetch
        fetch -o "${2}" "${1}"
    fi
}

while getopts "b:c:Cd:fhi:l:Ln:p:P:s:S:t:u:vV?" opt; do
    case ${opt} in
        b)
            SSPBASE="${OPTARG}"
            ;;
        c)
            if test "${OPTARG:0:1}" = "#" ; then
                OPTARG="${OPTARG:1}"
            fi
            if test "$(echo ${OPTARG:0:6} | tr -dc '0-9A-Fa-f')" = "${OPTARG}" ; then
                COLOUR="#${OPTARG}"
            else
                echo "ERROR: -c must specify a HTML colour in hex format (got ${OPTARG})" >&2; exit 1
            fi
            ;;
        C)
            if test "${OPTARG:0:1}" = "#" ; then
                OPTARG="${OPTARG#'#'}"
            fi
            if test "$(echo ${OPTARG:0:6} | tr -dc '0-9A-Fa-f')" = "${OPTARG}" ; then
                COMPLEMENT="#${OPTARG}"
            else
                echo "ERROR: -c must specify a HTML colour in hex format (got ${OPTARG})" >&2; exit 1
            fi
            ;;
        d)
            if test "${OPTARG:0:1}" = "/" -o "${OPTARG:0:1}" = "." ; then
                DIR="${OPTARG}"
            else
                DIR="${SSPBASE}/${OPTARG}"
            fi
            ;;
        f)
            FORCE=1
            ;;
        h)
            usage
            ;;
        i)
            if test "${OPTARG:0:5}" = "data:" -o "${OPTARG:0:7}" = "http://" -o "${OPTARG:0:8}" = "https://" -o -f "${OPTARG}"; then
                FAVICON="${OPTARG}"
            else
                echo "Error: -i must specify a URL or path to a favicon" >&2; exit 1
            fi
            ;;
        l)
            if test "${OPTARG:0:5}" = "data:" -o "${OPTARG:0:7}" = "http://" -o "${OPTARG:0:8}" = "https://" -o -f "${OPTARG}"; then
                LOGO="${OPTARG}"
            else
                echo "Error: -l must specify a URL or path to a logo" >&2; exit 1
            fi
            ;;
        L)
            LOGO_COPY=1
            ;;
        n)
            NAME="${OPTARG}"
            ;;
        p)
            if test "${OPTARG:0:7}" = "http://" -o "${OPTARG:0:8}" = "https://"; then
                PRIVACY_LINK="${OPTARG}"
            else
                echo "Error: -p must specify a URL" >&2; exit 1
            fi
            ;;
        P)
            PRIVACY_TEXT="${OPTARG}"
            ;;
        s)
            if test "${OPTARG:0:7}" = "http://" -o "${OPTARG:0:8}" = "https://"; then
                SUPPORT_LINK="${OPTARG}"
            else
                echo "Error: -s must specify a URL" >&2; exit 1
            fi
            ;;
        S)
            SUPPORT_TEXT="${OPTARG}"
            ;;
        t)
            THEME=$(echo ${OPTARG} | tr -dc 'a-zA-Z0-9_-')
            ;;
        u)
            if test "${OPTARG:0:7}" = "http://" -o "${OPTARG:0:8}" = "https://" ; then
                HOMEPAGE="${OPTARG}"
            else
                echo "Error: -u must specify a fully qualified URL for your homepage" >&2; exit 1
            fi
            ;;
        v)
            VERBOSE=1
            ;;
        V)
            echo "$(basename $0) version ${VERSION}" >&2; exit 1
            ;;
        \?)
            usage
            ;;
    esac
done

# name must be given
if test -z "${NAME}" ; then
    echo "Error: organisation name must be specified with -n" >&2; exit 1
fi

# defaults for other values
: ${SSPBASE:="."}
: ${COLOUR:="#666"}
: ${COMPLEMENT:=""}
: ${DIR:="${SSPBASE}/modules"}
: ${LOGO:=""}
: ${THEME:=$(hostname -s)}
: ${HOMEPAGE:=""}
: ${FAVICON:="${HOMEPAGE}/favicon.ico"}
: ${VERBOSE:=0}
: ${PRIVACY_TEXT:=Privacy statement}
: ${SUPPORT_TEXT:=Help & Support}
THEMEBASE="${DIR}/${THEME}"

if test '!' '(' -f "${SSPBASE}/templates/base.twig" -a -d "${SSPBASE}/modules/saml" -a -d "${SSPBASE}/src/SimpleSAML" -a -d "${SSPBASE}/public/assets/base" ')' ; then
    echo "Error: Could not find SimpleSAMLphp 2.x base at ${SSPBASE}" >&2; exit 1
fi

#
# SSP module directory structure
#
if test -e "${THEMEBASE}" -a ${FORCE:=0} -ne 1 ; then
    echo "Error: Cowardly refusing to overwrite existing ${DIR}/${THEME} directory" >&2
    echo "       Use -f to force or -t to change the theme name" >&2
    exit 1
else
    test $VERBOSE -ge 1 && echo "+ making directory structure" >&2
    mkdir -p "${THEMEBASE}" "${THEMEBASE}/public/assets/css" "${THEMEBASE}/public/assets/icons" "${THEMEBASE}/themes/${THEME}/default" || exit 1
fi

#
# Images
#

# try get a favicon
if test -f "${FAVICON}" ; then
    test $VERBOSE -ge 1 && echo "+ copying favicon from ${FAVICON}" >&2
    cp "${FAVICON}" "${THEMEBASE}/public/assets/icons/favicon.ico"
elif test -n "${FAVICON}" -a "${FAVICON:0:1}" != '/' ; then
    fetch "${FAVICON}" "${THEMEBASE}/public/assets/icons/favicon.ico"
else
    test $VERBOSE -ge 1 && echo "+ favicon could not be found at ${FAVICON:-unspecified}"
fi
if test '!' -s "${THEMEBASE}/public/assets/icons/favicon.ico" ; then
    echo "Warning: A favicon could not be included. To include one, save it as ${THEMEBASE}/public/assets/icons/favicon.ico" >&2
else
    # in case the browser uses the first one
    ln -sf "${THEMEBASE}/public/assets/icons/favicon.ico" "${SSPBASE}/public/assets/base/icons/favicon.ico"
fi

# turn homepage into opening and closing <a> tags
if test -n "${HOMEPAGE}"; then
    HOMEPAGE=$(printf '%s\n' "${HOMEPAGE}" | sed -e 's/[\/&]/\\&/g' -e 's/"/\\&quot;/g')
    HOMEPAGE_open="<a href=\"${HOMEPAGE}\">"
    HOMEPAGE_close='</a>'
fi

# handle the logo
if test -n "${LOGO}" -a -f "${LOGO}"; then
    # local copy
    test $VERBOSE -ge 1 && echo "+ copying logo from ${LOGO}" >&2
    cp "${LOGO}" "${THEMEBASE}/public/assets/icons/$(basename ${LOGO})" || exit 1
    LOGO_LINK="${HOMEPAGE_open}<img src=\"{{ asset('icons/$(basename ${LOGO})', '${THEME}') }}\" class=\"logo-icon\" alt=\"{{ header }}\">${HOMEPAGE_close}"
elif test -n "{$LOGO}" -a ${LOGO_COPY:=0} -eq 1; then
    # local copy of remote logo
    fetch "${LOGO}" "${THEMEBASE}/public/assets/icons/$(basename ${LOGO})"
    if test -s "${THEMEBASE}/public/assets/icons/$(basename ${LOGO})" ; then
        LOGO_LINK="${HOMEPAGE_open}<img src=\"{{ asset('icons/$(basename ${LOGO})', '${THEME}') }}\" class=\"logo-icon\" alt=\"{{ header }}\">${HOMEPAGE_close}"
    else
        echo "Warning: Logo could not be retrieved from ${LOGO}; treating as remote" >&2
        LOGO_LINK="${HOMEPAGE_open}<img src=\"${LOGO}\" class=\"logo-icon\" alt=\"{{ header }}\">${HOMEPAGE_close}"
    fi
elif test -n "${LOGO}" ; then
    # remote URL
    test $VERBOSE -ge 1 && echo "+ remote logo at ${LOGO}" >&2
    LOGO_LINK="${HOMEPAGE_open}<img src=\"${LOGO}\" class=\"logo-icon\" alt=\"{{ header }}\">${HOMEPAGE_close}"
else
    test $VERBOSE -ge 1 && echo "+ no logo specified" >&2
fi

#
# template files
#

# what follows needs GNU sed
if test -n "$(sed --help 2>&1 | grep GNU)" ; then
    SED=$(command -v sed)
elif test -x "$(command -v gsed)" -a -n "$(gsed --help 2>&1 | grep GNU)" ; then
    test $VERBOSE -ge 1 && echo "+ choosing gsed for GNU sed" >&2
    SED=$(command -v gsed)
else
    echo "Error: need GNU sed" >&2; exit 1
fi

# head
test $VERBOSE -ge 1 && echo "+ overriding <head> defaults in _head.twig" >&2
echo "{#
${NAME} SimpleSAMLphp theme
Generated by: $(basename $0) v${VERSION}
At: $(date)
File: _head.twig

This file is added to the <head> element, and allows us to add an additional
stylesheet, theme colour, etc to override the defaults.

#}
<link rel=\"stylesheet\" href=\"{{ asset('css/${THEME}.css', '${THEME}') }}\">
<link rel=\"shortcut icon\" href=\"{{ asset('icons/favicon.ico', '${THEME}') }}\">
<meta name=\"theme-color\" content=\"${COLOUR}\"/>
" > "${THEMEBASE}/themes/${THEME}/default/_head.twig"

# header
if test -n "${LOGO_LINK}" ; then
    test $VERBOSE -ge 1 && echo "+ copy _header.twig into template dir at ${THEMEBASE}/themes/${THEME}/default/" >&2
    cp "${SSPBASE}/templates/_header.twig" "${THEMEBASE}/themes/${THEME}/default/_header.twig" || exit 1
    test $VERBOSE -ge 1 && echo "++ applying replacements to _header.twig" >&2
    ${SED} -i -E -e '/<div id="logo">/,/<\/div>/D' \
        -e 's|^([[:space:]]*)(<div class="[^"]*logo-header[^"]*">)|\1\2\n\1  <div id="logo">\n\1    %LOGO%\n\1  </div>|' \
        -e "s|%LOGO%|${LOGO_LINK}|" \
        -e "1 s/^/{#\\n${NAME} SimpleSAMLphp theme\\nGenerated by: $(basename $0) v${VERSION}\\nAt: $(date)\\n File: _header.twig\\nThis is the header bar, and is only needed to use an image for the logo.\\nIf you're happy with a text-only name in the header, delete this file\\n\\n#}\\n/" \
        "${THEMEBASE}/themes/${THEME}/default/_header.twig"
fi

# footer
if test -n "${SUPPORT_LINK}" -o -n "${PRIVACY_LINK}" ; then
    test $VERBOSE -ge 1 && echo "+ copy _footer.twig into template dir at ${THEMEBASE}/themes/${THEME}/default/" >&2
    cp "${SSPBASE}/templates/_footer.twig" "${THEMEBASE}/themes/${THEME}/default/_footer.twig" || exit 1
    FOOTER="<div class=\"center footer-links\">"
    if test -n "${SUPPORT_LINK}"; then
        SUPPORT_TEXT=$(printf '%s\n' "${SUPPORT_TEXT}" | sed -e 's/[\/&]/\\&/g')
        FOOTER="${FOOTER}\n      <a href=\"${SUPPORT_LINK}\">{{ '${SUPPORT_TEXT}'|trans }}</a>"
    fi
    if test -n "${SUPPORT_LINK}" -a -n "${PRIVACY_LINK}" ; then
        FOOTER="${FOOTER}\n      <span class=\"separator\"> | </span>"
    fi
    if test -n "${PRIVACY_LINK}"; then
        PRIVACY_TEXT=$(printf '%s\n' "${PRIVACY_TEXT}" | sed -e 's/[\/&]/\\&/g')
        FOOTER="${FOOTER}\n      <a href=\"${PRIVACY_LINK}\">{{ '${PRIVACY_TEXT}'|trans }}</a>"
    fi
    FOOTER="${FOOTER}\n    </div>"
    test $VERBOSE -ge 1 && echo "++ applying replacements to _footer.twig" >&2
    ${SED} -i -E -e 's|^([[:space:]]*)(<div class="[^"]*copyrights[^"]*">)|\1%FOOTER%\n\1\2|' \
        -e "s!%FOOTER%!${FOOTER}!g" \
        -e "1 s/^/{#\\n${NAME} SimpleSAMLphp theme\\nGenerated by: $(basename $0) v${VERSION}\\nAt: $(date)\\nFile: _footer.twig\\n\\nThis is the footer bar, and is only needed to add privacy and\/or support links\\nto the footer. You can delete this file if you don't need these.\\n\\nThe link text is translatable if you add appropriate strings into the locale\/ files.\\n\\n#}\\n/" \
        "${THEMEBASE}/themes/${THEME}/default/_footer.twig"
fi

#
# write a CSS file
#
test $VERBOSE -ge 1 && echo "+ generating custom CSS file" >&2
echo "/*
 * ${NAME} SimpleSAMLphp theme
 * Generated by: $(basename $0) v${VERSION}
 * At: $(date)
 *
 * This CSS file is included after SimpleSAMLphp's default CSS and merely
 * overrides the default styling for this theme.
 */

:root {
  --theme-colour: ${COLOUR};
  --theme-up-complement: ${COMPLEMENT:-$(complement ${COLOUR} "+30")};
  --theme-dn-complement: ${COMPLEMENT:-$(complement ${COLOUR} "-30")};
}

/*
 * if your logo is displaying wrong, you most likely need to change
 * the width and height dimensions here.
 */
.logo-icon {
  padding: 0.5rem 0;
  height: calc(6rem - 1rem);
  width: auto;
}

#logo a:hover,
#logo a:focus {
  background-color: inherit;
  padding: inherit;
}

#header,
#footer {
  background: var(--theme-colour);
}

#menu {
  background: var(--theme-colour);
}

#menu .pure-menu-selected,
#menu .pure-menu-heading {
  background: var(--theme-up-complement);
}

#menu .pure-menu ul,
#menu .pure-menu .menu-item-divided {
  border-top: 1px solid var(--theme-dn-complement);
}
.pure-button-primary,
.pure-button-red {
  background-color: var(--theme-colour);
}

.pure-button-red:hover,
.pure-button-red:focus {
  background: var(--theme-dn-complement);
}

.logo-footer,
.copyrights {
  display: none;
}

.footer-links {
  padding-top: 0.5rem;
  height: 3.5rem;
  font-size: .8rem;
}
" > "${THEMEBASE}/public/assets/css/${THEME}.css"

#
# Add a README
#
echo "
# SimpleSAMLphp Theme for ${NAME}

This theme module was generated by $(basename $0) v${VERSION}
See [Theme generator for SimpleSAMLphp](https://safire.ac.za/technical/resources/simplesamlphp-theme-generator/) for info on this tool.

## Using the theme

To enable this theme, edit \`config/config.php\` and make the following two changes:

  * Enable the \`${THEME}\` module in \`module.enable\`
  * Set \`theme.use\` to \`${THEME}:${THEME}\`
  * Optionally set \`theme.header\` to \`${NAME}\`

## Regenerating the theme

To reproduce this theme (without any subsequent edits), you can run:

\`\`\`
$(basename $0) ${@@Q}
\`\`\`

" > "${THEMEBASE}/README.md"

# enable our theme in the stock config
if test '!' -f config/config.php ; then
    cp config/config.php.dist config/config.php || exit 1
fi
if test -f config/config.php.orig -a ${FORCE:=0} -ne 1 ; then
    echo "Warning: cannot back up config.php; you will need to enable theme manually" >&2
else
    cp config/config.php config/config.php.orig
    test $VERBOSE -ge 1 && echo "+ enable theme & theme module in config.php" >&2
    ${SED} -i -E \
        -e "s|(^[[:space:]]*'theme.use') => '[^']+',|\\1 => '${THEME}:${THEME}',|" \
        -e "s|^([[:space:]]*)/{0,2}'theme.header' => '[^']+',|\\1'theme.header' => '${NAME}',|"\
        -e "/^[[:space:]]*'module.enable' => \[/ {\$!N;{/${THEME}/! s/^([[:space:]]*)'module.enable' => \[\\n/\\s'module.enable' => [\\n\\1\\1'${THEME}' => true,\\n/}}" \
        config/config.php
fi
