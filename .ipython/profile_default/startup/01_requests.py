
try:

    def in_ipynb():
        try:
            cfg = get_ipython().config
            if cfg['IPKernelApp']['parent_appname'] == 'ipython-notebook':
                return True
            else:
                return False
        except NameError:
            return False


    from pygments import highlight
    from pygments.lexers import HttpLexer
    from pygments.lexers import XmlLexer, HtmlLexer, JsonLexer, TextLexer

    LEXER_MAP = {
        "html" : HtmlLexer,
        "json" : JsonLexer,
        "xml" : XmlLexer,
    }

    if in_ipynb():
        from pygments.formatters import HtmlFormatter
        formatter = HtmlFormatter(noclasses=True)
    else:
        from pygments.formatters import Terminal256Formatter
        formatter = Terminal256Formatter()
    import json
    import requests
    from IPython.display import HTML, display
    from IPython.core.magic import (Magics, magics_class, line_magic,
                                    cell_magic, line_cell_magic)

    def output(*parts):
        if in_ipynb():
            display(HTML("<br>".join(parts)))
        else:
            print "\n".join(parts)


    def get_lexer(response):
        target_lexer = TextLexer
        for string, lexer in LEXER_MAP.items():
            if string in response.headers["content-type"]:
                target_lexer = lexer
                break
        return target_lexer()


    @magics_class
    class RequestsMagic(Magics ):
        @line_magic
        def resp(self, line):
            response = self.shell.user_ns[line]
            headers = "\n".join(["{}: {}".format(h,v) for h,v in response.headers.items()])
            status_line = " ".join(["HTTP/1.1", str(response.status_code), response.reason])
            header_highlighted = highlight(status_line + "\n" + headers, HttpLexer(), formatter)

            lexer = get_lexer(response)
            content = response.content
            if 'json' in response.headers["content-type"]:
                content = json.dumps(response.json(), indent=4)

            response_highlighted = highlight(content, lexer, formatter)
            output(header_highlighted, response_highlighted)

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
            header_highlighted = highlight("\n".join([method, headers]), HttpLexer(), formatter)

            if response.request.body:
                request_body = response.request.body
                #request_highlighted = highlight(json.dumps(json.loads(response.request.body), indent=4), JsonLexer(), formatter)
                request_highlighted = request_body
            else:
                request_highlighted = ""
            output(header_highlighted, request_highlighted)

    ip = get_ipython()
    ip.register_magics(RequestsMagic)
except:
    pass
