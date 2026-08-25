#include <iostream>
#include "ad_blocker.h"

int main() {
    std::cout << "Inicializando Protótipo do Motor de Bloqueio" << std::endl;

    AdBlocker blocker;
    blocker.LoadDefaultFilters();

    std::string test_urls[] = {
        "https://www.google.com/search?q=open+source",
        "https://ads.g.doubleclick.net/tag/js/gpt.js",
        "https://github.com/seu-usuario/seu-navegador",
        "https://analytics.google.com/collect?v=1",
        "https://trackers.facebook.com/tr?id=12345"
    };

    std::cout << "\n--- TESTANDO REQUISIÇÕES DE REDE ---" << std::endl;

    for (const auto& url : test_urls) {
        bool blocked = blocker.ShouldBlock(url);
        std::cout << "URL: " << url << "\n -> Status: " 
                  << (blocked ? "[BLOQUEADO]" : "[PERMITIDO]") 
                  << "\n----------------------------------------" << std::endl;
    }

    return 0;
}
