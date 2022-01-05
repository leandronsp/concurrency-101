const { execSync } = require("child_process");

const times = () => {
  return Array.from(Array(50).keys())
}

const io = () => {
  execSync('sleep 0.005')
}

module.exports = {
  io,
  times
}
