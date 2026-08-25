#include "ad_blocker.h"
#include <iostream>

AdBlocker::AdBlocker() {}

void AdBlocker::AddRule(const std::string& pattern) {
    bool has_wildcard = (pattern.find('*') != std::string::npos);
    rules_.push_back({pattern, has_wildcard});
}

void AdBlocker::LoadDefaultFilters() {
    std::vector<std::string> default_rules = {
        "ads.g.doubleclick.net",         
        "*.doubleclick.net/*",           
        "*analytics*",                   
        "https://trackers.facebook.com/*" 
    };

    for (const auto& rule : default_rules) {
        AddRule(rule);
    }
}

bool AdBlocker::MatchWildcard(const std::string& pattern, const std::string& text) const {
    size_t p_len = pattern.length();
    size_t t_len = text.length();
    size_t p_idx = 0, t_idx = 0;
    size_t star_idx = std::string::npos;
    size_t match_idx = 0;

    while (t_idx < t_len) {
        if (p_idx < p_len && (pattern[p_idx] == text[t_idx] || pattern[p_idx] == '*')) {
            if (pattern[p_idx] == '*') {
                star_idx = p_idx;
                match_idx = t_idx;
                p_idx++;
            } else {
                p_idx++;
                t_idx++;
            }
        } else if (star_idx != std::string::npos) {
            p_idx = star_idx + 1;
            match_idx++;
            t_idx = match_idx;
        } else {
            return false;
        }
    }

    while (p_idx < p_len && pattern[p_idx] == '*') {
        p_idx++;
    }

    return p_idx == p_len;
}

bool AdBlocker::ShouldBlock(const std::string& url) const {
    for (const auto& rule : rules_) {
        if (rule.is_wildcard) {
            if (MatchWildcard(rule.pattern, url)) {
                return true;
            }
        } else {
            if (url.find(rule.pattern) != std::string::npos) {
                return true;
            }
        }
    }
    return false;
}
