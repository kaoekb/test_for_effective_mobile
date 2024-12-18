### Этот репозиторий содержит службу и таймер systemd для мониторинга процесса test на Linux. Скрипт проверяет, запущен ли процесс, отправляет данные на сервер мониторинга и записывает события.

#### Требования
Linux с установленным `systemd`
Установлен `curl`
Файлы `test-monitor.service`, `test-monitor.timer`, и `monitoring.sh` должны быть доступны

#### Установка

1. Клонируйте репозиторий

    `git clone https://github.com/kaoekb/test_for_effective_mobile.git`

    `cd test_for_effective_mobile`

2. Установите права на выполнение скрипта

    `chmod +x monitoring.sh`

3. Установите службу и таймер

    `make install`

3. Проверка статуса службы

    `make status`

4. Просмотр логов
    `make logs`

#### Удаление
1.  Для остановки службы и удаления файлов конфигурации

    `make clean`

2.  Для удаления только логов

    `make clear-logs`

```
Описание команд
make install — устанавливает и запускает службу.
make status — проверяет статус службы и выводит логи.
make clean — останавливает службу, удаляет файлы конфигурации и логи.
make clear-logs — удаляет только логи.
make logs - показывает /var/log/monitoring.log
```