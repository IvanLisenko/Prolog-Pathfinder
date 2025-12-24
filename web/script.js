const cities = [
  "Симферополь", "Алушта", "Белогорск", "Саки",
  "Октябрьское", "Красноперекопск", "Севастополь",
  "Ялта", "Судак", "Феодосия", "Приморский",
  "Керчь", "Армянск", "Красногвардейское", "Джанкой",
  "Алупка", "Форос", "Кореиз", "Партенит",
  "Гурзуф", "Бахчисарай", "Инкерман", "Балаклава",
  "Кировское", "Первомайское", "Черноморское",
  "Мирный", "Нижнегорский", "Раздольное", "Евпатория",
  "Коктебель", "Старый Крым", "Щёлкино", "Красносельское",
  "Советский", "Красноармейское", "Массандра",
  "Урожайное", "Солнечногорское", "Новозёрное"
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
  "Приморский": "primorskiy",
  "Керчь": "kerch",
  "Армянск": "armyansk",
  "Красногвардейское": "krasnogvardeyskoye",
  "Джанкой": "dzhankoi",
  "Алупка": "alupka",
  "Форос": "foros",
  "Кореиз": "koreiz",
  "Партенит": "partenity",
  "Гурзуф": "gurzuf",
  "Бахчисарай": "bakhchisaray",
  "Инкерман": "inkerman",
  "Балаклава": "balaklava",
  "Кировское": "kirovskoye",
  "Первомайское": "pervomayskoye",
  "Черноморское": "chernomorskoye",
  "Мирный": "mirnyy",
  "Нижнегорский": "nizhnegorskiy",
  "Раздольное": "razdo",
  "Евпатория": "yevpatoriya",
  "Коктебель": "koktebel",
  "Старый Крым": "staryi_krym",
  "Щёлкино": "shcholkino",
  "Красносельское": "krasnoselskoye",
  "Советский": "sovietskiy",
  "Красноармейское": "krasnoarmeyskoye",
  "Массандра": "massandra",
  "Урожайное": "urozhaynoye",
  "Солнечногорское": "solnechnogorskoye",
  "Новозёрное": "novozyornoye"
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
  const result = document.getElementById('result');

  if (!from || !to) {
    result.innerText = "Введите корректные города из списка.";
    return;
  }

  try {
    const res = await fetch(`/find?from=${from}&to=${to}`);
    const data = await res.json();

    if (data.error) {
      result.innerText = data.error;
      return;
    }

    result.innerHTML = `
      <div class="result-row">
        <div class="icon">📏</div>
        <div class="text"><b>Расстояние:</b> ${data.distance} км</div>
      </div>

      <div class="result-row">
        <div class="icon">⏱</div>
        <div class="text"><b>Время:</b> ${data.time} мин</div>
      </div>

      <div class="route-block">
        <div class="result-row">
          <div class="icon">🗺</div>
          <div class="text"><b>Маршрут</b></div>
        </div>
        <div class="route">
          ${data.route.join(' → ')}
        </div>
      </div>
    `;

    drawRoute(data.route);

  } catch (err) {
    result.innerText = 'Ошибка запроса к серверу';
    console.error(err);
  }
});


function drawRoute(route) {
  const svg = document.getElementById("graph");
  svg.innerHTML = "";

  if (!route || route.length === 0) return;

  const width = svg.clientWidth;
  const height = svg.clientHeight;

  const maxPerRow = 2;              // сколько городов в одном ряду
  const rows = Math.ceil(route.length / maxPerRow);

  const paddingX = 30;
  const paddingY = 30;

  const rowHeight = (height - paddingY * 2) / rows;
  const colWidth = (width - paddingX * 2) / maxPerRow;

  let prev = null;

  route.forEach((city, i) => {
    const row = Math.floor(i / maxPerRow);
    const col = i % maxPerRow;

    const x = paddingX + col * colWidth + colWidth / 2;
    const y = paddingY + row * rowHeight + rowHeight / 2;

    // линия
    if (prev) {
      const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
      line.setAttribute("x1", prev.x);
      line.setAttribute("y1", prev.y);
      line.setAttribute("x2", x);
      line.setAttribute("y2", y);
      line.setAttribute("stroke", "#0078d7");
      line.setAttribute("stroke-width", "2");
      svg.appendChild(line);
    }

    // круг
    const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
    circle.setAttribute("cx", x);
    circle.setAttribute("cy", y);
    circle.setAttribute("r", 9);
    circle.setAttribute("fill", "#005bb5");
    svg.appendChild(circle);

    // подпись
    const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
    text.setAttribute("x", x);
    text.setAttribute("y", y + 26);
    text.setAttribute("text-anchor", "middle");
    text.setAttribute("font-size", "12");
    text.setAttribute("fill", "#333");
    text.textContent = city;
    svg.appendChild(text);

    prev = { x, y };
  });
}


