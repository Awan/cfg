from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *


class Scheme(ColorScheme):
    progress_bar_color = blue

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            if context.empty or context.error:
                bg = red
            if context.border:
                fg = default

            # file types
            if context.link:
                if context.good:
                    fg = 14 # bright cyan
                else:
                    fg = 9 # bright red
            elif context.directory:
                # has to come after link
                # otherwise, links to directories will be miscolored
                attr |= bold
                fg = 12 # bright blue
            elif context.socket or context.fifo:
                fg = 13 # bright magenta
            elif context.device:
                fg = 11 # bright yellow
            elif context.image:
                fg = yellow
            elif context.video or context.audio:
                fg = magenta
            elif context.container:
                fg = red
            elif context.executable:
                # we intentionally check this case last
                # to avoid miscoloring directories
                fg = 10 # bright green

            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red

            if not context.selected and (context.cut or context.copied):
                fg = 8 # bright black
                attr |= bold

            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = 11 # bright yellow
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

            if context.inactive_pane:
                fg = cyan

        elif context.in_titlebar:
            if context.hostname:
                fg = context.bad and red or green
            elif context.directory:
                attr |= bold
                fg = 12 # bright blue
            elif context.link:
                attr |= bold
                fg = 14 # bright cyan
            elif context.tab:
                if context.good:
                    attr |= reverse

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = cyan
                elif context.bad:
                    fg = magenta
            if context.marked:
                attr |= bold | reverse
                fg = 11 # bright yellow
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = blue
                attr &= ~bold
            if context.vcscommit:
                fg = yellow
                attr &= ~bold
            if context.vcsdate:
                fg = cyan
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = blue

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = magenta
            elif context.vcschanged:
                fg = red
            elif context.vcsunknown:
                fg = red
            elif context.vcsstaged:
                fg = green
            elif context.vcssync:
                fg = green
            elif context.vcsignored:
                fg = default

        elif context.vcsremote and not context.selected:
            attr &= ~bold
            if context.vcssync or context.vcsnone:
                fg = green
            elif context.vcsbehind:
                fg = red
            elif context.vcsahead:
                fg = blue
            elif context.vcsdiverged:
                fg = magenta
            elif context.vcsunknown:
                fg = red

        return fg, bg, attr
