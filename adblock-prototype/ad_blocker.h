#ifndef AD_BLOCKER_H
#define AD_BLOCKER_H

#include <string>
#include <vector>

struct FilterRule {
    std::string pattern;
    bool is_wildcard;
};

class AdBlocker {
public:
    AdBlocker();
    ~AdBlocker() = default;

    void AddRule(const std::string& pattern);
    void LoadDefaultFilters();
    bool ShouldBlock(const std::string& url) const;

private:
    std::vector<FilterRule> rules_;

    bool MatchWildcard(const std::string& pattern, const std::string& text) const;
};

#endif 
