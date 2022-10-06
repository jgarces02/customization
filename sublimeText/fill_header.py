import sublime_plugin
#https://forum.sublimetext.com/t/snippet-with-dynamic-character-length/33601/3

class InsertHeaderCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        rulers = self.view.settings().get("rulers", [])
        maxlength = min(rulers) if rulers else 80
        if len(self.view.sel()) > 1:
            print("This doesn't work with more than one selection :(")
            return
        region = self.view.sel()[0]
        # If we have an empty region, assume we want to convert the whole line.
        if region.empty():
            region = self.view.line(region.begin())
        print('handling', self.view.substr(region), region)
        # -4 for '/** '
        # -1 for the space between the region and the start of the dashes.
        # Totals -5.
        dashlength = maxlength - region.size() - 5
        if dashlength < 0:
            print("Region is too large:", self.view.substr(region))
            return
        string = "{} {}$0".format(self.view.substr(region),
                                                "#" * dashlength)
        self.view.erase(edit, region)
        self.view.run_command("insert_snippet", {"contents": string})
