#include <iostream>
#include <mutex>
#include <thread>
#include<string>
#include <clocale>
#include <vector>

//16. Задача о клумбе. На клумбе растет 40 цветов, за ними непрерывно
//следят два садовника и поливают увядшие цветы, при этом оба садовника
//очень боятся полить один и тот же цветок. Создать многопоточное
//приложение, моделирующее состояния клумбы и действия садовников. Для
//изменения состояния цветов создать отдельный поток.

using namespace std;

mutex mtx;
static int gardenBeds[40]; // 0 - is okay // 1 - needs to be watered

// функция для генерации count не политых клеток в течение какого-то времени
// параллельно с работой садовников
void changeGarden(int count) {
    for (int i = 0; i < count; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(1200));
        int index = rand() % 40;
        gardenBeds[index] = 1;
        string outp = to_string(index) + " cell needs to be watered\n";
        cout<<outp;
    }
}

// функция полития грядки
void waterCell(int ind, int threadId) {
    if (gardenBeds[ind] == 0) {
        return;
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));

    string outp = to_string(ind) + " has been watered by " + to_string(threadId) + "gardener \n";
    gardenBeds[ind] = 0;
    cout<<outp;
}

// функция для распределения задач по политию грядок между двумя садовниками
// сс - изначально введенное количество грядок, которое сгенерируется неполитыми
void chooseCellToWater(int cc, int threadId) {

    for (int j = 0; j < cc; j++ ) {
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        mtx.lock();
        // находим неполитую грядку
        for (int i = 0; i < 40; ++i) {
            if (gardenBeds[i] == 1) {
                waterCell(i, threadId);
                break;
            }
            if (i == 39)
                cout << "nothing to water\n";
        }
        mtx.unlock();
    }
}


int main() {
    setlocale(LC_ALL, "ru_RU.UTF-8");

    int actionsNum;
    cin>>actionsNum; // вводим кол-во случаев, когда грядка захочет быть политой

    if (actionsNum <= 0)
        return 1;
    // данный поток с какой-то переодичностью делает какую-то клетку не политой
    thread gardenChanger(changeGarden, actionsNum * 2);

    // эти потоки мониторят грядки и в случае нахождения не политой - поливают
    // причем поливает только 1 из двух садовников
    thread gardener1(chooseCellToWater, actionsNum, 1);
    thread gardener2(chooseCellToWater, actionsNum, 2);

    gardenChanger.join();
    gardener1.join();
    gardener2.join();
    return 0;
}
