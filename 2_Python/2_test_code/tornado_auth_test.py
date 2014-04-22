#!/usr/bin/env python

import tornado.ioloop
import tornado.web

class BaseHandler(tornado.web.RequestHandler):
    def get_current_user(self):
        return self.get_secure_cookie("user")

class MainHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        name = tornado.escape.xhtml_escape(self.current_user)
        self.write("Hello, " + name)
        self.write("<p><a href='/logout'>logout</a></p>")

user_info={}

class LoginHandler(BaseHandler):
    def get(self):
        self.write('<html><body><form action="/login" method="post">'
                   'Name: <input type="text" name="name">'
                   'Password: <input type="password" name="password">'
                   '<input type="submit" value="Sign in">'
                   '</form></body></html>')

    def post(self):
        if self.get_argument("name") not in user_info:
            user_info[self.get_argument("name")] = self.get_argument("password")
        elif user_info[self.get_argument("name")] != self.get_argument("password"):
            self.redirect("/")
        self.set_secure_cookie("user", self.get_argument("name"))
        self.redirect("/")

class LogoutHandler(BaseHandler):
    def get(self):
        self.clear_cookie("user")
        self.redirect("/")

settings = {
    "cookie_secret": "__TODO:_GENERATE_YOUR_OWN_RANDOM_VALUE_HERE__",
    "login_url": "/login"
}

application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/login", LoginHandler),
    (r"/logout", LogoutHandler),
], **settings)

if __name__ == "__main__":
    application.listen(8880)
    tornado.ioloop.IOLoop.instance().start()
