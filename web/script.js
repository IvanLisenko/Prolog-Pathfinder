const cities = [
  "Симферополь", "Алушта", "Белогорск", "Саки",
  "Октябрьское", "Красноперекопск", "Севастополь",
  "Ялта", "Судак", "Феодосия", "Приморский",
  "Керчь", "Армянск", "Красногвардейское", "Джанкой"
];

const cityMap = {
  "Симферополь": "simferopol",
  "Алушта": "alushta",
  "Белогорск": "belogorsk",
  "Саки": "saki",
  "Октябрьское": "oktyabrskoye",
  "Красноперекопск": "krasnoperekopsk",
  "Севастополь": "sevastopol",
  "Ялта": "yalta",
  "Судак": "sudak",
  "Феодосия": "feodosiya",
  "Приморский": "primorskyi",
  "Керчь": "kerch",
  "Армянск": "armyansk",
  "Красногвардейское": "krasnogvardeiskoe",
  "Джанкой": "dzhankoi"
};

// функция для автоподсказок
function setupAutocomplete(inputId, suggestionsId) {
  const input = document.getElementById(inputId);
  const suggestions = document.getElementById(suggestionsId);

  input.addEventListener('input', () => {
    const val = input.value.toLowerCase();
    suggestions.innerHTML = '';

    if (!val) return;

    const filtered = cities.filter(c => c.toLowerCase().startsWith(val));
    filtered.forEach(city => {
      const div = document.createElement('div');
      div.textContent = city;
      div.className = 'suggestion-item';
      div.addEventListener('click', () => {
        input.value = city;
        suggestions.innerHTML = '';
      });
      suggestions.appendChild(div);
    });
  });

  document.addEventListener('click', (e) => {
    if (!input.contains(e.target)) {
      suggestions.innerHTML = '';
    }
  });
}

// подключаем автоподсказки к обоим полям
setupAutocomplete('from', 'suggestions-from');
setupAutocomplete('to', 'suggestions-to');

// обработчик формы
document.getElementById('route-form').addEventListener('submit', async (e) => {
  e.preventDefault();

  const fromRus = document.getElementById('from').value;
  const toRus = document.getElementById('to').value;

  const from = cityMap[fromRus];
  const to = cityMap[toRus];

  if (!from || !to) {
    document.getElementById('result').innerText = "Введите корректные города из списка.";
    return;
  }

  try {
    const res = await fetch(`/find?from=${from}&to=${to}`);
    const data = await res.json();

    if (data.error) {
      document.getElementById('result').innerText = data.error;
    } else {
      document.getElementById('result').innerText =
        `Расстояние: ${data.distance} км, Время: ${data.time} мин\nМаршрут: ${data.route.join(' -> ')}`;
    }
  } catch (err) {
    document.getElementById('result').innerText = 'Ошибка запроса к серверу';
    console.error(err);
  }
});
