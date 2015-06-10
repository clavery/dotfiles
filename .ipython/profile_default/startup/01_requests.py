
try:
    from pygments import highlight
    from pygments.lexers import JsonLexer, HttpLexer
    from pygments.formatters import HtmlFormatter
    import json
    import requests
    from IPython.display import HTML, display
    from IPython.core.magic import (Magics, magics_class, line_magic,
                                    cell_magic, line_cell_magic)

    @magics_class
    class RequestsMagic(Magics ):
        @line_magic
        def resp(self, line):
            response = self.shell.user_ns[line]
            headers = "\n".join(["{}: {}".format(h,v) for h,v in response.headers.items()])
            status_line = " ".join(["HTTP/1.1", str(response.status_code), response.reason])
            header_highlighted = highlight(status_line + "\n" + headers, HttpLexer(), HtmlFormatter(noclasses=True))
            response_highlighted = highlight(json.dumps(response.json(), indent=4), JsonLexer(), HtmlFormatter(noclasses=True))

            display(HTML(header_highlighted + "<br>" + response_highlighted))

        @line_magic
        def fmt(self, line):
            self.req(line)
            self.resp(line)

        @line_magic
        def req(self, line):
            response = self.shell.user_ns[line]
            headers = "\n".join(["{}: {}".format(h,v) for h,v in response.request.headers.items()])
            method = " ".join([response.request.method, response.request.path_url])
            method = method + " HTTP/1.1"
            header_highlighted = highlight("\n".join([method, headers]), HttpLexer(), HtmlFormatter(noclasses=True))
            if response.request.body:
                request_highlighted = highlight(json.dumps(json.loads(response.request.body), indent=4), JsonLexer(), HtmlFormatter(noclasses=True))
            else:
                request_highlighted = ""
            display(HTML(header_highlighted + request_highlighted))
    ip = get_ipython()
    ip.register_magics(RequestsMagic)
except:
    pass
