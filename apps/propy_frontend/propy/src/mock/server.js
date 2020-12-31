const jsonServer = require('json-server');
const loginController = require('./login/index');

const app = jsonServer.create();
const middleware = jsonServer.defaults(); // Default middlewares (logger, static, cors and no-cache)
const port = process.env.PORT || 3000;

app.use(middleware);
app.use(jsonServer.bodyParser); // for POST, PUT, PATCH

app.post('/api/login', loginController.login);
app.get('/api/login/refresh_token', loginController.refreshToken);
app.get('/api/greetings', (req, res) => {
  res.status(200).json("Hi");
});

app.listen(port, () => {
  console.log(`\n\n... JSON Server Running. Open the browser at http://localhost:${port}\n\n`);
});
