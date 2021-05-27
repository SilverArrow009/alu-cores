#include<vector>
#include<bitset>
#include<iostream>

using namespace std;

// Generate the series of threshold 'd'
vector<int> generate_d(int limit) {
    vector<int> d;
    d.push_back(2);
    while (true) {
        if(*d.rbegin() >= limit ) {
            return d;
    }
        d.push_back(3 * (*d.rbegin()) / 2); 
    }
}

vector<int> d = generate_d(64);

class column
{
    column::column(unsigned col_depth){
        col.resize(col_depth);
        column_depth = col_depth;
    }
    public :
        unsigned column_depth;
        vector<int> col;
        vector<int> col_carry_out;
        
        // Add elements at the beginning 
        void add(vector<bool> x) {
            for(int i=1; i <= x.size(); i++) {
                col.insert(col.begin() + i, x[i-1]);
            }
            return;
        }

        // Write the entire column
        void write(vector<bool> x) {
            for (int i = 1; i <= col.size(); i++)
            {
                col.insert(col.begin() + i, x[i-1]);
            }
            return;
        }

        // Compress the column
        void compress(int stage) {
            int compress_threshold = *d.rbegin();
            int compress_amount = (col.size() - compress_threshold);
            if (compress_amount < 0) {
                return;
            } else {
                
            }
        }
};
