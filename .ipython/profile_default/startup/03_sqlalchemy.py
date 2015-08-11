try:
    from IPython.display import HTML, display
    from IPython.core.magic import (Magics, magics_class, line_magic,
                                    cell_magic, line_cell_magic)

    @magics_class
    class SQLAMagic(Magics):
        @line_magic
        def sqlo(self, line):
            result = self.shell.user_ns[line]
            header =  "<th>#</th>" + "".join(["<th>%s</th>" % k for k in result.keys()])
            rows = "\n".join([("<tr><th>%s</th>" % i) + "".join(["<td>%s</td>" % a for a in r]) + "</tr>"
                            for i, r in enumerate(result)])

            display(HTML("""
            <table class="dataframe">
            <thead>
            <tr>
            %s
            </tr>
            </thead>
            <tbody>
            %s
            </tbody>
            </table>
            """ % (header, rows)))

    ip = get_ipython()
    ip.register_magics(SQLAMagic)
except:
    pass
