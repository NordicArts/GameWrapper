#include "Main.hpp"
#include <NordicEngine/Engine.hpp>
#include <Game/Game.hpp>

namespace NordicArts {
    int Main() {
        return Game::Main("Valkyrie");
    }
};

int main() {
    return NordicArts::Main();
}
