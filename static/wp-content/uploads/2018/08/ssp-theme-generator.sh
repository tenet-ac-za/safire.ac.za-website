#!/usr/bin/env bash
#
# Bash script to generate a simple SSP theme based on the default template
#
# @author Guy Halse http://orcid.org/0000-0002-9388-8592
#
VERSION=20180806

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
 -p <col>   complementary colour as HTML hex value [default: calculated]

 -b <dir>   the base directory of SimpleSAMLphp [default: .]
 -d <dir>   module output directory [default: <sspbase>/modules]
 -f         force overwriting
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

while getopts "b:c:d:fhi:l:n:p:t:u:vV?" opt; do
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
        n)
            NAME="${OPTARG}"
            ;;
        p)
            if test "${OPTARG:0:1}" = "#" ; then
                OPTARG="${OPTARG#'#'}"
            fi
            if test "$(echo ${OPTARG:0:6} | tr -dc '0-9A-Fa-f')" = "${OPTARG}" ; then
                COMPLEMENT="#${OPTARG}"
            else
                echo "ERROR: -c must specify a HTML colour in hex format (got ${OPTARG})" >&2; exit 1
            fi
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
THEMEBASE="${DIR}/${THEME}"

if test '!' '(' -d "${SSPBASE}/templates" -a -d "${SSPBASE}/modules" -a -d "${SSPBASE}/lib/SimpleSAML" ')' ; then
    echo "Error: Could not find SimpleSAMLphp base at ${SSPBASE}" >&2; exit 1
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
    mkdir -p "${THEMEBASE}" "${THEMEBASE}/www" "${THEMEBASE}/themes/${THEME}/default/includes" || exit 1
fi
touch "${THEMEBASE}/default-enable"

#
# Images
#

# try get a favicon
if test -f "${FAVICON}" ; then
    test $VERBOSE -ge 1 && echo "+ copying favicon from ${FAVICON}" >&2
    cp "${FAVICON}" "${THEMEBASE}/www/favicon.ico"
elif test -n "${FAVICON}" -a "${FAVICON:0:1}" != '/' ; then
    test $VERBOSE -ge 1 && echo -n "+ attempting to fetch favicon from ${FAVICON} using " >&2
    if test -x "$(command -v wget)"; then
        test $VERBOSE -ge 1 && echo wget
        wget -q -O "${THEMEBASE}/www/favicon.ico" "${FAVICON}"
    elif test -x "$(command -v curl)"; then
        test $VERBOSE -ge 1 && echo curl
        curl -s "${FAVICON}" -o "${THEMEBASE}/www/favicon.ico"
    elif test -x "$(command -v fetch)"; then
        test $VERBOSE -ge 1 && echo fetch
        fetch -o "${THEMEBASE}/www/favicon.ico" "${FAVICON}"
    fi
else
    test $VERBOSE -ge 1 && echo "+ favicon could not be found at ${FAVICON:-unspecified}"
fi
if test '!' -s "${THEMEBASE}/www/favicon.ico" ; then
    echo "Warning: A favicon could not be included. To include one, save it as ${THEMEBASE}/www/favicon.ico" >&2
fi

# turn homepage into opening and closing <a> tags
if test -n "${HOMEPAGE}"; then
    HOMEPAGE_open="<a href=\"${HOMEPAGE}\">"
    HOMEPAGE_close='</a>'
fi

# handle the logo
if test -n "${LOGO}" -a -f "${LOGO}" ; then
    # local copy
    test $VERBOSE -ge 1 && echo "+ copying logo from ${LOGO}" >&2
    cp "${LOGO}" "${THEMEBASE}/www/$(basename ${LOGO})" || exit 1
    LOGO_ssp="${HOMEPAGE_open}<img src=\"<?php echo SimpleSAML\Module::getModuleURL('${THEME}/$(basename ${LOGO})'); ?>\" alt=\"${NAME}\">${HOMEPAGE_close}"
    LOGO_twig="${HOMEPAGE_open}<img src=\"/{{ baseurlpath }}module.php/${THEME}/$(basename ${LOGO})\" alt=\"${NAME}\">${HOMEPAGE_close}"
elif test -n "${LOGO}" ; then
    # remote URL
    test $VERBOSE -ge 1 && echo "+ remote logo at ${LOGO}" >&2
    LOGO_ssp="${HOMEPAGE_open}<img src=\"${LOGO}\" alt=\"${NAME}\">${HOMEPAGE_close}"
    LOGO_twig="${LOGO_ssp}"
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

# copy the relevant bits of the default templates
test $VERBOSE -ge 1 && echo "+ copy files into template dir at ${THEMEBASE}/themes/${THEME}/default/" >&2
for file in includes/footer.php includes/header.php base.twig _footer.twig _header.twig ; do
    test $VERBOSE -ge 1 && echo "  ++ copying ${file} into template dir" >&2
    cp "${SSPBASE}/templates/${file}" "${THEMEBASE}/themes/${THEME}/default/${file}" || exit 1
done

# header (legacy)
test $VERBOSE -ge 1 && echo "+ applying replacements to legacy header" >&2
${SED} -i -E -e "s|'SimpleSAMLphp'|'${NAME}'|" \
    -e 's|^([[:space:]]+<link.*?href=").*resources/default.css|\1<?php echo SimpleSAML\\Module::getModuleURL("%THEME%/%THEME%.css"); ?>|' \
    -e 's|^([[:space:]]+<link.*?href=").*favicon.ico|\1<?php echo SimpleSAML\\Module::getModuleURL("%THEME%/favicon.ico"); ?>|' \
    -e 's|(<div id="header">)|\1\n\t\t%LOGO%|' \
    -e 's|(<meta name="robots".*)$|\1\n\t<meta name="theme-color" content="%THEMECOLOUR%"/>|' \
    -e "s|%THEME%|${THEME}|g" \
    -e "s|%LOGO%|${LOGO_ssp}|g" \
    -e "s|%THEMECOLOUR%|${COLOUR}|g" \
    "${THEMEBASE}/themes/${THEME}/default/includes/header.php"

# header (twig)
test $VERBOSE -ge 1 && echo "+ applying replacements to twig header" >&2
${SED} -i -E -e 's|(<div id="header">)|\1\n\t\t%LOGO%|' \
    -e "s|%LOGO%|${LOGO_twig}|g" \
    "${THEMEBASE}/themes/${THEME}/default/_header.twig"

# base (twig)
test $VERBOSE -ge 1 && echo "+ applying replacements to twig base" >&2
${SED} -i -E \
    -e 's|^([[:space:]]+<link.*?href=").*resources/default.css|\1/{{ baseurlpath }}module.php/%THEME%/%THEME%.css|' \
    -e 's|^([[:space:]]+<link.*?href=").*favicon.ico|\1/{{ baseurlpath }}module.php/%THEME%/favicon.ico|' \
    -e 's|(<meta name="robots".*)$|\1\n\t<meta name="theme-color" content="%THEMECOLOUR%"/>|' \
    -e "s|%THEME%|${THEME}|g" \
    -e "s|%THEMECOLOUR%|${COLOUR}|g" \
    "${THEMEBASE}/themes/${THEME}/default/base.twig"

# footer (legacy & twig)
test $VERBOSE -ge 1 && echo "+ applying replacements to legacy & twig footers" >&2
${SED} -i -E -e 's|^([[:space:]]+<img)|<!--\n \1|' \
    -e 's|(UNINETT AS</a>)$|\1\n-->\n\t\t%FOOTR%|' \
    -e 's|%FOOTR%|<span class="float-r">%NAME%<\/span>|g' \
    -e "s|%NAME%|${HOMEPAGE_open}${NAME}${HOMEPAGE_close}|g" \
    "${THEMEBASE}/themes/${THEME}/default/includes/footer.php" \
    "${THEMEBASE}/themes/${THEME}/default/_footer.twig"

#
# write a CSS file
#
test $VERBOSE -ge 1 && echo "+ generating CSS file" >&2
echo "/*
 * ${NAME} SimpleSAMLphp theme
 * Generated by: $(basename $0)
 * At: $(date)
 *
 * This CSS file incorporates SimpleSAMLphp's default CSS and merely
 * overrides elements to style this theme.
 */
@import url('../../resources/default.css');

body {
    /*
     * specify the background colour of the entire page as a very light
     * colour, since most corporate image colours are designed to work on
     * paper and thus with a white background.
     */
    background: #fafafa;
}

#wrap {
    /* center the main block within the page */
    margin: 20px auto;
    /*
     * specify the border around the main block as a complementary colour.
     * by default this is the +30' adjacent and the header border is the
     * corresponding -30' adjacent. You can also try swapping them, or if
     * your corporate style guide specifies complementary colours, use them.
     */
    border: 1px solid ${COMPLEMENT:-$(complement ${COLOUR} "+30")};
}

#header {
    /* set the background of the header block to our corporate colour */
    background: ${COLOUR};
    /* and set the bottom border to complement the #wrap border colour */
    border-bottom: 1px solid ${COMPLEMENT:-$(complement ${COLOUR} "-30")};
}

/* if we have a logo, put it on the right and fit it in the header */
#header img {
    float: right;
    display: inline;
    border: none;
    height: 64px;
    margin: 4px 12px;
}

/* put our name in small words on the bottom of every page */
#footer {
    font-size: smaller;
    padding-bottom: 0.1rem;
}

/* make small screens use the corporate colour as a background */
@media handheld, only screen and (max-width: 480px), only screen and (max-device-width: 480px) {
    body {
        background: ${COLOUR};
    }
}
" > "${THEMEBASE}/www/${THEME}.css"

test $VERBOSE -ge 1 && echo "" >&2
echo "
Your theme has been generated as a module named \"${THEME}\"

To use this theme, add
    'theme.use' => '${THEME}:${THEME}',
into config/config.php
"
