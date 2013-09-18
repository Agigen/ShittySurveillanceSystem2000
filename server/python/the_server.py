import tornado.ioloop
import tornado.web
import json

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        #self.write("Hello, world")
        response = { 'toilets': [ { 'title':k, 'occupied':v } for k,v in PiState.get_state().iteritems() ],
                     }
        self.write(json.dumps(response))

class PiState(object):
    #import piface.pfio as pfio
    #pfio.init()
    #TODO: Bind digital inputs and switches (for test)
    switches = { 'door1': True,
                 'door2': True,
                 'door3': True,
                }

    @classmethod
    def get_state(cls):
        return cls.switches


application = tornado.web.Application([
    (r"/", MainHandler),
])

if __name__ == "__main__":
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
