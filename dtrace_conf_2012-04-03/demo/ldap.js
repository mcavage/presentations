var server = require('ldapjs').createServer();

server.search('o=example', function(req, res, next) {
    var obj = {
        dn: req.dn.toString(),
        attributes: {
            o: 'example',
            objectclass: ['organization', 'top']
        }
    };

    if (req.filter.matches(obj.attributes))
        res.send(obj);

    res.end();
});

server.listen(1389, function () {
    console.error('server up at %s', server.url);
});
