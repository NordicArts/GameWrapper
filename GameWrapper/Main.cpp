#include "Main.hpp"
#include <NordicEngine/Engine.hpp>
#include <Game/Game.hpp>

namespace NordicArts {
    int Main() {
        return Game::Main();
    }
};

int main() {
    return NordicArts::Main();
}
