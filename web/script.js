document.getElementById('route-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const from = document.getElementById('from').value;
  const to = document.getElementById('to').value;
  const res = await fetch(`/find?from=${from}&to=${to}`);
  const data = await res.json();
  document.getElementById('result').innerText =
    data.error ? data.error : `Distance: ${data.distance} km, Time: ${data.time} min, Route: ${data.route.join("->")}`;
});
