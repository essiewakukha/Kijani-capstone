const http = require('http');
const { randomUUID } = require('crypto');
const PORT = process.env.PORT || 8080;

http.createServer((req, res) => {
  const correlationId = req.headers['x-correlation-id'] || randomUUID();
  const log = { timestamp: new Date().toISOString(), level: 'info', correlationId, path: req.url };
  console.log(JSON.stringify(log));
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ status: 'ok', correlationId }));
}).listen(PORT, () => console.log(JSON.stringify({ level: 'info', message: `listening on ${PORT}` })));
