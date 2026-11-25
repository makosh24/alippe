# Alippe

Детский букварь: казахский алфавит и сказки. Приложение работает офлайн, в альбомной ориентации. Ребёнок листает буквы, слышит звук и открывает слова-картинки.

## Запуск

```bash
flutter pub get
flutter run
```

Нужен Flutter 3.41 (Dart 3.11) или новее.

## Что внутри

- 42 буквы казахского кириллического алфавита, одна лента.
- Звук буквы и до четырёх слов. Если картинки или звука нет, экран не падает: остаётся слово текстом.
- Раздел «Ертегілер»: несколько готовых сказок и свои. При чтении подсвечивается текущее слово. Свою сказку можно записать с аудио, выгрузить архивом и загрузить обратно.
- Родительский режим: после проверки можно заменить картинку или голос и перенести эти замены архивом. После закрытия приложения снова детский режим.

Картинки лежат в `assets/images/predmets`, звуки в `assets/audio`. Если имя в данных и имя файла расходятся, соответствие записано в `lib/src/components/AlphabetsComponents/media_names.dart`.

## Подпись Android

Пароли keystore читаются из `key.properties` в корне проекта. Этот файл и `*.jks` не должны попадать в git. Debug-сборка использует обычный debug-ключ.

## Текст для App Store

Версия **1.2.1**. Вставить в карточку как есть. В описании не писать про `Info.plist`, разрешения и сборку: это не для пользователя.

### Description

```
Alippe — детский букварь казахского алфавита.

Ребёнок листает 42 буквы, нажимает букву, слышит её звук и смотрит слова с картинками. Приложение работает без интернета и открывается горизонтально.

В разделе «Ертегілер» есть готовые сказки. Пока сказка читается, текущее слово подсвечивается. Сказка «Үйрек туралы ертегі» звучит голосом, остальные читаются с той же подсветкой.

Родитель проходит короткую проверку и может заменить картинку или голос у слова, добавить свою сказку с записью и перенести эти материалы на другое устройство. Когда приложение закрывают, снова включается детский режим.

Аккаунт не нужен. Рекламы нет, данные ребёнка не собираются.
```

### What’s New

```
Сказки можно слушать и читать: текущее слово подсвечивается. Добавлены готовые сказки, своя сказка с голосом и родительская замена картинок и звуков букв. На главном экране кнопки больше не закрывают буквы.
```

### App Review Information

Эти поля видит только ревьюер. Вход не включайте: аккаунта нет.

| Поле | Что вписать |
|---|---|
| Sign-in required | выключено |
| First name | Madi |
| Last name | Yedenbay |
| Phone number | свой номер в международном виде, например `+7…` |
| Email | MEdenbai@gmail.com |

Notes:

```
Alippe (com.macoffice.alippe) is a Kazakh alphabet primer for children. The interface is Kazakh. The app is landscape only: rotate the device sideways. It works offline.

No account, login, ads, in-app purchases, or subscriptions. Sign-in required should stay off.

How to review:
1. Launch the app. The home screen shows a row of letters. Swipe the row and tap the large center letter. The next screen plays the letter sound and shows up to four picture words. Tap a picture to hear its word.
2. Tap Ертегілер (top left) for fairy tales. Open the first tale, Үйрек туралы ертегі. It has a recording, and the current word is highlighted while the audio plays. The other built-in tales have no recording: tap Оқу and the words highlight at a reading pace. Pause is the same button.
3. Tap the gear (Баптаулар) for settings. The child mode cannot edit content. Tap Ата-анаға өту. A parent gate asks for the product of two numbers from 6 to 9, for example 7 × 8 = 56. Type the digits and tap Тексеру. A wrong answer shows a new problem.
4. After the gate, the parent can add, edit, export, and import tales from Ертегілер, and can replace a word picture or voice from a letter screen. Replacing a picture asks for the photo library. That access is only for a picture the parent chooses. Closing the app returns to child mode.

Pictures, voices, and custom tales stay on the device. Nothing is uploaded.
```

## Скриншоты

Пять кадров лежат в пяти размерах. Приложение только горизонтальное, поэтому и кадры горизонтальные. Загружайте папку целиком, по порядку от `01` до `05`. Экран не обрезан: если пропорция слота другая, по краям поле цвета этого же снимка.

- Google Play, телефон: `docs/store/android/phone`, 2160×1080.
- App Store, iPhone 6,9 дюйма: `docs/store/ios/iphone-6.9`, 2868×1320.
- App Store, iPhone 6,3 дюйма: `docs/store/ios/iphone-6.3`, 2622×1206. Этот размер принимается и в слот 6,1 дюйма.
- App Store, iPhone Duo, внутренний экран: `docs/store/ios/iphone-duo`, 2853×2007.
- App Store, iPad 13 дюймов: `docs/store/ios/ipad-13`, 2752×2064. Нужен, потому что сборка открывается и на iPad.

Порядок: главный экран, слова буквы, список сказок, ещё один экран слов, настройки.

Исходники были 1280×588, поэтому на витрине текст будет чуть мягче, чем снимок прямо с телефона.

Шапка страницы в App Store: `docs/store/ios/header/header-3840x1646.png`, 3840×1646. Её перетаскивают в поле Header Asset. Название и знак стоят в центре, где витрина их не обрезает.

Картинка для поиска в App Store: `docs/store/ios/search/search-3840x2560.png`, 3840×2560. Её перетаскивают в поле Search Results Asset.

## Проверки

```bash
flutter test
flutter analyze
```
