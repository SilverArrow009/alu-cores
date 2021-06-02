#include<vector>
#include<fstream>
#include<iostream>
#include<cmath>

#define NO_VERIFY

using namespace std;

// Open the file to write the report for parsing
ofstream fout("dadda_multiplier_summary.txt");

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
            col_carry_out.clear();
            int compress_threshold = *d.rbegin();
            int compress_amount = (col.size() - compress_threshold);
            unsigned n_full_adders, n_half_adders, n_carry;
            if (compress_amount <= 0) {
                fout << "No optimization required\n" << endl;
                return;
            } else {
                n_full_adders = compress_amount / 2;
                n_half_adders = compress_amount - 2*n_full_adders;
                n_carry = n_full_adders + n_half_adders;
                // fout << "Full adders utilized :" << n_full_adders << ", Half adders utilized : " << n_half_adders << ", carries generated : " << n_carry << endl;
                if (n_full_adders !=0) {
                    use_full_adders(n_full_adders);
                }
                if (n_half_adders != 0) {
                    use_half_adders(n_half_adders, n_full_adders);
                }
            }
        }
    
    private :
        // Full adder compression logic
        void use_full_adders(int n_full_adders) {
            bool carry;
            fout << "Inserting full adders at positions : ";
            for (int i = 0; i < n_full_adders; i++)
            {
                fout << 3*i << " ";
                carry = (bool) (((int)col[i+1] & (int) col[i+2]) | (((int)col[i+1] ^ (int) col[i+2]) & (int) col[i])); // c_out = Gi + Pi . Ci
                col[i] = (bool)((int)col[i] ^ (int)col[i+1] ^ (int)col[i+2]); // sum = Pi ^ c_in
                col.erase(col.begin()+i+1, col.begin()+i+3);
                col_carry_out.push_back(carry);
            }
            fout << "\n" << endl;
            return;
        }

       // Half adder compression logic
        void use_half_adders(int n_half_adders, int origin) {
            bool carry;
            fout << "Inserting half adders at positions : ";
            int j;
            for (int i = 0; i < n_half_adders; i+=2)
            {
                fout << 3*origin + i << " ";
                j = origin + i;
                carry = (bool) (((int)col[j] & (int) col[j+1])); // c_out = Gi + Pi . Ci
                col[j] = (bool)((int)col[j] ^ (int)col[j+1]); // sum = Pi
                col.erase(col.begin()+j+1, col.begin()+j+2);
                col_carry_out.push_back(carry);
            }
            fout << "\n" << endl;
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
            // fout << "In stage " << stage << ":" << endl;
            for (int i = 0; i < column_array.size(); i++)
            {
                if (i != column_array.size()-1) {
                    fout << "In column : " << i << endl;
                    // Compress the column
                    column_array[i].compress(stage);
                    // Add the resulting carry to the next column
                    column_array[i+1].add(column_array[i].col_carry_out);
                    fout << ""; //debug
                } else {
                    fout << "In column : " << i << endl;
                    //Compress the final column
                    column_array[i].compress(stage);
                    fout << ""; //debug
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

// Log max sizes of the columns
void log_max_size_cols (Tree mul_tree, vector<unsigned> &max_cols_sizes) {
    for (int i = 0; i < mul_tree.column_array.size(); i++)
    {
        max_cols_sizes[i] = (max_cols_sizes[i] < mul_tree.column_array[i].col.size()) ? mul_tree.column_array[i].col.size() : max_cols_sizes[i];
    }
}

// Drive the code

int main() {
    vector<bool> op1(4,1);
    vector<bool> op2(4,1);
    int size = op1.size();
    Tree mul_tree = Tree(size, op1, op2);
    // Initialize the tree
    mul_tree.initialize();
    // Populate the d-vector
    d = generate_d(size);
    int number_stages = d.size();
    // Initialize the max size cols
    vector<unsigned> max_size_cols(2*size-1);
    log_max_size_cols(mul_tree, max_size_cols);
    // Run the Dadda algorithm
    for (int i = 0; i < number_stages; i++)
    {
        // Step through the algortihm
        mul_tree.step(i);
        // Update the max cols after each step
        log_max_size_cols(mul_tree, max_size_cols);
        d.pop_back();
    }

    for (int i = 0; i < max_size_cols.size(); i++)
    {
        fout << "Max size of register at column : " << i << " : " << max_size_cols[i] << endl << endl;
    }
    
    #ifndef NO_VERIFY

    // verification of algorithm
    unsigned long result1 = 0;
    unsigned long result2 = 0;
    for (int i = 0; i < mul_tree.column_array.size(); i++)
    {
        if(i == 0) {
            result1 += mul_tree.column_array[i].col[0]; 
        } else {
            result1 += pow(2,i) * mul_tree.column_array[i].col[0];
            result2 += pow(2,i) * mul_tree.column_array[i].col[1]; 
        }
    }
    unsigned long product = result1 + result2;
    fout << "Product is : " << product << endl;

    #endif
    fout.close();
    return 0;
}