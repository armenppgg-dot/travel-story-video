# travel-story-video

## Рендер первой сцены в MP4

### Команда

```bash
./scripts/render-scene1.sh
```

### Где появляется итоговый файл

- `output/scene1.mp4`

### Как проверить результат

```bash
ffprobe output/scene1.mp4
```

## Что уже учтено

- Сцена рендерится как: одно фото + лёгкий zoom/motion + маленькая машина снизу + короткий звук машины + без музыки.
- Если `ffmpeg` не установлен, скрипт автоматически скачает статический бинарник в `tools/ffmpeg/ffmpeg`.
- Для полностью воспроизводимого запуска в репозитории добавлен GitHub Actions workflow:
  - `.github/workflows/render-scene1.yml`
  - запуск вручную через **Actions → Render Scene 1 MP4 → Run workflow**
  - результат скачивается из артефакта `scene1-mp4`.

> Если в `assets/scene1/photo.jpg` уже лежит фото первой сцены, используется оно.
> Если файла нет, создаётся минимальный `photo.jpg`, чтобы рендер не падал.
