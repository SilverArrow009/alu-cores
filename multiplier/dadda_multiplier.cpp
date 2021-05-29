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

vector<int> d;

class Column
{
    public :
        // Overloading the constructor while preserving the default one
        Column(){

        }

        Column(unsigned col_depth){
            col.resize(col_depth);
            column_depth = col_depth;
        }
        unsigned column_depth;
        vector<bool> col;
        vector<bool> col_carry_out;
        
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
            unsigned n_full_adders, n_half_adders, n_carry;
            if (compress_amount < 0) {
                return;
            } else {
                n_full_adders = compress_amount / 2;
                n_half_adders = compress_amount - 2*n_full_adders;
                n_carry = n_full_adders + n_half_adders;
                cout << "Full adders utilized :" << n_full_adders << ", Half adders utilized : " << n_half_adders << " ,carries generated : " << n_carry << endl;
                use_full_adders(n_full_adders);
                use_half_adders(n_half_adders, 3*n_full_adders);
            }
        }
    
    private :
        // Full adder compression logic
        void use_full_adders(int n_full_adders) {
            bool carry;
            if (n_full_adders)
            {
                return;
            } else {
                cout << "inserting full adders at positions : ";
                for (int i = 0; i < n_full_adders; i++)
                {
                    cout << 3*i << ", ";
                    carry = (bool) (((int)col[i+1] & (int) col[i+2]) | (((int)col[i+1] ^ (int) col[i+2]) & (int) col[i])); // c_out = Gi + Pi . Ci
                    col[i] = (bool)((int)col[i] ^ (int)col[i+1] ^ (int)col[i+2]); // sum = Pi ^ c_in
                    col.erase(col.begin()+i+2, col.begin()+i+4);
                    col_carry_out.push_back(carry);
                }
            }
            return;
        }

       // Half adder compression logic
        void use_half_adders(int n_half_adders, int origin) {
            bool carry;
            if (n_half_adders)
            {
                return;
            } else {
                cout << "inserting half adders at positions : ";
                for (int i = origin; i < n_half_adders; i+=2)
                {
                    cout << i << ", ";
                    carry = (bool) (((int)col[i] & (int) col[i+1])); // c_out = Gi + Pi . Ci
                    col[i] = (bool)((int)col[i] ^ (int)col[i+1]); // sum = Pi
                    col.erase(col.begin()+i+2, col.begin()+i+3);
                    col_carry_out.push_back(carry);
                }
            }
            return;
        }
};

class Tree {
    public :    
        Tree(int size, vector<bool> op1, vector<bool> op2) {
            multiplier_size = size;
            int i;
            for (i = 0; i <= size; i++)
            {
                generate_col_sizes.push_back(i);
            }
            for (; i <= 2*size; i++)
            {
                generate_col_sizes.push_back(i);
            }
            multiplicand.resize(size); multiplicand = op1;
            multiplier.resize(size); multiplier = op2;
            column_array.resize(2*size);
        }

        int multiplier_size;
        vector<unsigned> generate_col_sizes;
        vector<bool> multiplicand, multiplier;
        vector<Column> column_array;
        
        // Initialize the tree
        void initialize() {

            int i = 0;
            vector<Column>::iterator colarray_it = column_array.begin();
            vector<unsigned>::iterator colsize_it = generate_col_sizes.begin();
            while (i < 2*multiplier_size)
            {
                *colarray_it = Column(*colsize_it);
                // Insert the population logic here
                column_array[i].write(generate_col_values(i));
                // Increments
                i++;
                colarray_it++;
                colsize_it++;
            }
        }

        void step(int stage) {
            cout << "In stage " << stage << ":" << endl;
            for (int i = 0; i < column_array.size(); i++)
            {
                if (i != column_array.size()-1) {
                    // Compress the column
                    column_array[i].compress(stage);
                    // Add the resulting carry to the next column
                    column_array[i+1].add(column_array[i].col_carry_out);
                } else {
                    //Compress the final column
                    column_array[i].compress(stage);
                }
            }
            
        }
    
    private :
        // Define a scheme to write to each column
        vector<bool> generate_col_values (int weight) {
            vector<bool> result;
            for (int i=0; i <= weight; i++) {
                result.push_back(multiplier[i] && multiplicand[weight - i]);
            }
            return result;
        } 
};

// Drive the code

int main() {
    vector<bool> op1{0,0,0,1};
    vector<bool> op2{1,0,1,0};
    int size = 4;
    Tree mul_tree = Tree(size, op1, op2);
    // Initialize the tree
    mul_tree.initialize();
    // Populate the d-vector
    d = generate_d(size);
    // Run the Dadda algorithm
    for (int i = 0; i < d.size(); i++)
    {
        mul_tree.step(i);
    }
    // Any cleanup task goes here
    return 0;
}