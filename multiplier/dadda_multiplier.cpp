#include<vector>
#include<bitset>
#include<iostream>

using namespace std;

class column
{
    column::column(unsigned column_depth){
        col.resize(column_depth);
    }
    public :
        unsigned column_depth;
        vector<int> col;
        
        // Add elements at the beginning 
        void add(vector<bool> x) {
            for(int i=1; i <= x.size(); i++) {
                col.insert(col.begin() + i, x[i-1]);
            }
        }

        // Write the entire column
        void write(vector<bool> x) {
            for (int i = 1; i <= col.size(); i++)
            {
                col.insert(col.begin() + i, x[i-1]);
            }
            
        }
};
