#include <iostream>
#include <vector>

int main() {
    std::vector<int> a = {2, 3, 1, 4, 5};
    int max = a[0];
    for (auto i = 1u; i < a.size(); ++i) {
        if (a[i] > max) {
            max = a[i];
        }
    }
    std::cout << "max = " << max << std::endl;
    return 0;
}
