#ifndef AD_BLOCKER_H
#define AD_BLOCKER_H

#include <string>
#include <unordered_set>
#include <vector>

class AdBlocker {
public:
    AdBlocker();
    ~AdBlocker() = default;

    void AddRule(const std::string& domain);
    void LoadDefaultFilters();
    bool ShouldBlock(const std::string& url) const;

private:
    std::unordered_set<std::string> blocked_domains_;
    std::string ExtractDomain(const std::string& url) const;
};

#endif 
