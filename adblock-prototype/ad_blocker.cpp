#include "ad_blocker.h"
#include <algorithm>
#include <iostream>

AdBlocker::AdBlocker() {}

void AdBlocker::AddRule(const std::string& domain) {
    blocked_domains_.insert(domain);
}

void AdBlocker::LoadDefaultFilters() {
  
    std::vector<std::string> default_rules = {
        "ads.g.doubleclick.net",
        "analytics.google.com",
        "trackers.facebook.com",
        "adserver.yahoo.com",
        "telemetry.malicious-tracker.io"
    };

    for (const auto& domain : default_rules) {
        AddRule(domain);
    }
}

std::string AdBlocker::ExtractDomain(const std::string& url) const {

    size_t start = url.find("://");
    if (start == std::string::npos) {
        start = 0;
    } else {
        start += 3;
    }

    size_t end = url.find('/', start);
    if (end == std::string::npos) {
        end = url.length();
    }

    return url.substr(start, end - start);
}

bool AdBlocker::ShouldBlock(const std::string& url) const {
    std::string domain = ExtractDomain(url);

    if (blocked_domains_.find(domain) != blocked_domains_.end()) {
        return true;
    }

    return false;
}
