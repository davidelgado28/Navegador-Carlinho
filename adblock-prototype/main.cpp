#include <iostream>
#include "ad_blocker.h"

int main() {
    std::cout << "Inicializando Protótipo Avançado" << std::endl;

    AdBlocker blocker;
    blocker.LoadDefaultFilters();

    std::string test_urls[] = {
        "https://www.google.com/search?q=open-source",
        "https://subdomain.doubleclick.net/ads/banner.js", 
        "https://example.com/analytics/collector.gif",    
        "https://trackers.facebook.com/tr?id=999",        
        "https://github.com/seu-usuario/projeto"
    };

    std::cout << "\n--- TESTANDO REQUISIÇÕES COM WILDARDS ---" << std::endl;

    for (const auto& url : test_urls) {
        bool blocked = blocker.ShouldBlock(url);
        std::cout << "URL: " << url << "\n -> Status: " 
                  << (blocked ? "[BLOQUEADO]" : "[PERMITIDO]") 
                  << "\n----------------------------------------" << std::endl;
    }
    return 0;
}
