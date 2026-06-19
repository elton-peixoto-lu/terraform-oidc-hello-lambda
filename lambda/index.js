exports.handler = async function handler() {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      message: "hello world"
    })
  };
};

