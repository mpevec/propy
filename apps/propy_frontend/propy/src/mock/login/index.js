
const jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MDkzNTU3MzksImdyb3VwcyI6WyJhZG1pbiJdLCJpc3MiOiJNYXR0aGlldSBMYWJzIFNSTCIsIm5hbWUiOiJKb2huIERvZSIsInN1YiI6MX0.cD_c7guEyZjTUsnf0S1F1CecNc2spE0m2ROJKbW_qzg";

const login = (req, res) => {
  return res.status(200).json(
    {
      jwt,
    }
  );
};

const refreshToken = (req, res) => {
  return res.status(200).json(
    {
      jwt,
    }
  );
}

exports.login = login;
exports.refreshToken = refreshToken;

