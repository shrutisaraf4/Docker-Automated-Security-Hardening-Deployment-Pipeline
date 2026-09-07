const http = require('http');

const port = 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, {
    'Content-Type': 'text/plain'
  });

  res.end('✅ Hardened Container App is Running Safely!\n');
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
