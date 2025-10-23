const cities = [
  "Симферополь", "Севастополь", "Керчь", "Евпатория",
  "Феодосия", "Ялта", "Джанкой", "Бахчисарай", 
  "Армянск", "Красноперекопск", "Алушта", "Судак",
  "Щёлкино", "Белогорск", "Саки", "Старый Крым",
  "Инкерман", "Гурзуф", "Алупка", "Массандра",
  "Кореиз", "Форос", "Балаклава", "Коктебель",
  "Орджоникидзе", "Прибрежное", "Раздольное", "Советский",
  "Красногвардейское", "Первомайское", "Нижнегорский", "Мирный",
  "Черноморское", "Красноармейское", "Войково", "Кировское",
  "Красносельское", "Медведево", "Новоозёрное", "Октябрьское",
  "Партенит", "Приморский", "Солнечногорское", "Урожайное",
  "Холмовка", "Щебетовка"
];

const cityMap = {
  "Симферополь": "simferopol", "Севастополь": "sevastopol",
  "Керчь": "kerch", "Евпатория": "yevpatoriya",
  "Феодосия": "feodosiya", "Ялта": "yalta",
  "Джанкой": "dzhankoi", "Бахчисарай": "bakhchisaray",
  "Армянск": "armyansk", "Красноперекопск": "krasnoperekopsk",
  "Алушта": "alushta", "Судак": "sudak",
  "Щёлкино": "shcholkino", "Белогорск": "belogorsk",
  "Саки": "saki", "Старый Крым": "staryi krym",
  "Инкерман": "inkerman", "Гурзуф": "gurzuf",
  "Алупка": "alupka", "Массандра": "massandra",
  "Кореиз": "koreiz", "Форос": "foros",
  "Балаклава": "balaklava", "Коктебель": "koktebel",
  "Орджоникидзе": "ordzhonikidze", "Прибрежное": "pribrizhnoye",
  "Раздольное": "razdolnoye", "Советский": "sovetskiy",
  "Красногвардейское": "krasnogvardeyskoye", "Первомайское": "pervomayskoye",
  "Нижнегорский": "nizhnegorskiy", "Мирный": "mirnyy",
  "Черноморское": "chernomorskoye", "Красноармейское": "krasnoarmeyskoye",
  "Войково": "voikovo", "Кировское": "kirovskoye",
  "Красносельское": "krasnoselskoye", "Медведево": "medvedevo",
  "Новоозёрное": "novozyornoye", "Октябрьское": "oktyabrskoye",
  "Партенит": "partenity", "Приморский": "primorskiy",
  "Солнечногорское": "solnechnogorskoye", "Урожайное": "urozhaynoye",
  "Холмовка": "kholmovka", "Щебетовка": "shchebetovka"
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
  document.getElementById('result').innerText = "Загрузка...";

  try {
    const res = await fetch(`/find?from=${from}&to=${to}`);
    const data = await res.json();

    if (data.error) {
      document.getElementById('result').innerText = data.error;
    } else {
      document.getElementById('result').innerText =
        `Расстояние: ${data.distance} км, Время: ${(data.time - data.time % 60) / 60} ч. ${data.time % 60} мин.\nМаршрут: ${data.route.join(' -> ')}`;
    }
  } catch (err) {
    document.getElementById('result').innerText = 'Ошибка запроса к серверу';
    console.error(err);
  }
});
