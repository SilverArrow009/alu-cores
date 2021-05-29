#include<vector>
#include<bitset>
#include<iostream>
#include<cmath>

using namespace std;

// Generate the series of threshold 'd'
vector<int> generate_d(int limit) {
    vector<int> d;
    d.push_back(2);
    while (true) {
        if(*d.rbegin() >= limit ) {
            d.pop_back();
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
            col.insert(col.begin(), x.begin(), x.end());
            return;
        }

        // Write the entire column
        void write(vector<bool> x) {
            col = x;
            return;
        }

        // Compress the column
        void compress(int stage) {
            int compress_threshold = *d.rbegin();
            int compress_amount = (col.size() - compress_threshold);
            unsigned n_full_adders, n_half_adders, n_carry;
            if (compress_amount <= 0) {
                cout << "\t\tNo optimization required" << endl;
                return;
            } else {
                n_full_adders = compress_amount / 2;
                n_half_adders = compress_amount - 2*n_full_adders;
                n_carry = n_full_adders + n_half_adders;
                cout << "\t\tFull adders utilized :" << n_full_adders << ", Half adders utilized : " << n_half_adders << ", carries generated : " << n_carry << endl;
                if (n_full_adders !=0) {
                    use_full_adders(n_full_adders);
                }
                if (n_half_adders != 0) {
                    use_half_adders(n_half_adders, 3*n_full_adders);
                }
            }
        }
    
    private :
        // Full adder compression logic
        void use_full_adders(int n_full_adders) {
            bool carry;
            cout << "\t\tinserting full adders at positions : ";
            col_carry_out.clear();
            for (int i = 0; i < n_full_adders; i+=3)
            {
                cout << i << " ";
                carry = (bool) (((int)col[i+1] & (int) col[i+2]) | (((int)col[i+1] ^ (int) col[i+2]) & (int) col[i])); // c_out = Gi + Pi . Ci
                col[i] = (bool)((int)col[i] ^ (int)col[i+1] ^ (int)col[i+2]); // sum = Pi ^ c_in
                col.erase(col.begin()+i+1, col.begin()+i+3);
                col_carry_out.push_back(carry);
            }
            cout << endl;
            return;
        }

       // Half adder compression logic
        void use_half_adders(int n_half_adders, int origin) {
            bool carry;
            cout << "\t\tinserting half adders at positions : ";
            col_carry_out.clear();
            for (int i = 0; i < n_half_adders; i+=2)
            {
                cout << origin + i << " ";
                carry = (bool) (((int)col[i] & (int) col[i+1])); // c_out = Gi + Pi . Ci
                col[i] = (bool)((int)col[i] ^ (int)col[i+1]); // sum = Pi
                col.erase(col.begin()+i+1, col.begin()+i+2);
                col_carry_out.push_back(carry);
            }
            cout << endl;
            return;
        }
};

class Tree {
    public :    
        Tree(int size, vector<bool> op1, vector<bool> op2) {
            multiplier_size = size;
            int i;
            for (i = 1; i < size; i++)
            {
                generate_col_sizes.push_back(i);
            }
            for (; i >= 1; i--)
            {
                generate_col_sizes.push_back(i);
            }
            multiplicand.resize(size); multiplicand = op1;
            multiplier.resize(size); multiplier = op2;
            column_array.resize(2*size-1);
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
            while (i < 2*multiplier_size-1)
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
            cout << "In stage " << stage << ":\n" << endl;
            for (int i = 0; i < column_array.size(); i++)
            {
                if (i != column_array.size()-1) {
                    cout << "\tIn column " << i << " :" << endl;
                    // Compress the column
                    column_array[i].compress(stage);
                    // Add the resulting carry to the next column
                    column_array[i+1].add(column_array[i].col_carry_out);
                    cout << ""; //debug
                } else {
                    cout << "\tIn column " << i << " :" << endl;
                    //Compress the final column
                    column_array[i].compress(stage);
                    cout << ""; //debug
                }
            }
            
        }
    
    private :
        // Define a scheme to write to each column
        vector<bool> generate_col_values (int weight) {
            vector<bool> result;
            int j;
            for (int i=0; i <= weight; i++) {
                j = weight - i;
                if (i < multiplier.size() && j < multiplier.size())
                {
                    result.push_back(multiplier[i] && multiplicand[j]);                    
                } else{
                    continue;
                }
            }
            return result;
        } 
};

// Drive the code

int main() {
    vector<bool> op1{1,1,1,1};
    vector<bool> op2{1,0,1,0};
    int size = op1.size();
    Tree mul_tree = Tree(size, op1, op2);
    // Initialize the tree
    mul_tree.initialize();
    // Populate the d-vector
    d = generate_d(size);
    int number_stages = d.size();
    // Run the Dadda algorithm
    for (int i = 0; i < number_stages; i++)
    {
        mul_tree.step(i);
        d.pop_back();
    }
    // verification of algorithm
    unsigned result1 = 0;
    unsigned result2 = 0;
    for (int i = 0; i < mul_tree.column_array.size(); i++)
    {
        if(i == 0) {
            result1 += mul_tree.column_array[i].col[0]; 
        } else {
            result1 += pow(2,i) * mul_tree.column_array[i].col[0];
            result2 += pow(2,i) * mul_tree.column_array[i].col[1]; 
        }
    }
    unsigned product = result1 + result2;
    cout << "Product is : " << product << endl;
    return 0;
}