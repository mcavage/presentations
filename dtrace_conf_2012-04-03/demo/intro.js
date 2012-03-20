var server = require('restify').createServer({
    name: 'foo'
});

server.use(function slowDown(req, res, next) {
    setTimeout(function () {
        return next();
    }, 513);
});

server.get('/hello/:name', function echo(req, res, next) {
    res.send('hello ' + req.params.name);
    return next();
});

server.listen(8080, function() {
    console.log('%s listening at %s', server.name, server.url);
});
