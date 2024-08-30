#include <bits/stdc++.h>
using namespace std;

// Global Variables for x86
map<string, map<string, string>> off;
map<string, map<string, int>> off_of_cls;
map<string, string> store_string;
vector<string> output;
vector<string> temp;
string curr_function = "global";
string current_class = "";
int cur_stri = 1;
int off_curr = -8;
int off_class = 0;
int param = 0;
int off_parm = 16;
int returned = 0;

void push_into_vector()
{
    for (int i = 0; i < temp.size(); i++)
        output.push_back(temp[i]);
}
vector<string> parseStringIntoVector(const string &input)
{
    vector<string> tokens;
    istringstream iss(input);
    string word;
    while (iss >> word)
    {
        if (word[0] == '\"' && word.back() != '\"')
        {
            string sanjay;
            word += " ";

            while (iss >> sanjay && sanjay.back() != '\"')
            {
                word += sanjay;
                word += " ";
            }
            word += sanjay;
        }
        if (word[0] == '\'' && word.back() != '\'')
        {
            string sanjay;
            word += " ";

            while (iss >> sanjay && sanjay.back() != '\'')
            {
                word += sanjay;
                word += " ";
            }
            word += sanjay;
        }
        if (word[0] == '\'' && word.back() == '\'')
        {
            word[0] = '\"';
            word.back() = '\"';
        }
        tokens.push_back(word);
    }

    for (int i = tokens.size(); i < 5; i++)
        tokens.push_back("");
    return tokens;
}

string check_arith(string s)
{
    // only for - , * , + //
    if (s == "-")
        return "subq";
    if (s == "*")
        return "imulq";
    if (s == "+")
        return "addq";
    return "";
}
string check_rel(string s)
{
    // only for >, < , <=, >= ,== ,!= //
    if (s == ">")
        return "setg";
    if (s == "<")
        return "setl";
    if (s == "!=")
        return "setne";
    if (s == "<=")
        return "setle";
    if (s == "==")
        return "sete";
    if (s == ">=")
        return "setge";
    return "";
}

int Is_Id(string s)
{
    if (s[0] == '@')
        return true;
    if (s == "popparameter" || s == "param" || s == "return" || s == "stackpointer")
        return false;
    for (int i = 0; i < s.size(); i++)
    {
        if (!isalnum(s[i]) && s[i] != '_')
            return false;
    }
    if ((s[0] >= '0' && s[0] <= '9'))
        return false;
    return true;
}

string check_logical(string s)
{
    // only for ^ , { | or }, { & and }, { ~ not } //
    if (s == "^")
        return "xorq";
    if (s == "|" || s == "or")
        return "orq";
    if (s == "&" || s == "and")
        return "andq";
    if (s == "~" || s == "not")
        return "not";
    return "";
}

string before_dot(string s)
{
    // return "";
    size_t pos = s.find('.');
    if (pos != string::npos)
    {
        return s.substr(0, pos);
    }
    else
    {
        return "";
    }
}

string after_dot(string s)
{
    //  return "";
    size_t pos = s.find('.');
    if (pos != string::npos)
    {
        return s.substr(pos + 1);
    }
    else
    {
        return "";
    }
}

void solve(vector<string> words)
{
    int i = 0;
    for (i = 0; i < words.size(); i++)
    {
        if (words[i].empty())
            return;
        if (before_dot(words[i]) == "self")
        {
            string name = after_dot(words[i]);
            if (off_of_cls[current_class].find(name) == off_of_cls[current_class].end())
            {
                off_of_cls[current_class][name] = off_class;
                off_class += 8;
                continue;
            }
        }
        if (words[i][0] == '"' || words[i][0] == '\'')
        {
            // cout<<"hehehehehehehehehe";
            string t = "string" + to_string(cur_stri);
            cur_stri++;
            store_string[t] = words[i];
            off[curr_function][words[i]] = "lea " + t + "(%rip), %rdx";
            continue;
        }
        if (Is_Id(words[i]))
        {
            if (off[curr_function].find(words[i]) == off[curr_function].end())
            {
                off[curr_function][words[i]] = to_string(off_curr) + "(%rbp)";
                off_curr -= 8;
            }
        }
        else
        {
            off[curr_function][words[i]] = "$" + words[i];
        }
    }
}

int main(int argc, char *argv[])
{

    // remember that all temporary variables starts with @1 , @2

    if (argc < 2)
    {
        cerr << "Usage: " << argv[0] << " <input_file>" << endl;
        return 1;
    }

    // Open the input file specified as the first command-line argument
    ifstream inputFile(argv[1]);

    if (!inputFile.is_open())
    {
        cerr << "Error: Unable to open input file." << endl;
        return 1;
    }

    // Read contents from the input file into a vector of strings
    vector<string> arguments;
    string line;

    while (getline(inputFile, line))
    {
        arguments.push_back(line);
        // cout << arguments.back()<<'\n';
    }
    inputFile.close();

    output.push_back("\n\n.data\n");
    output.push_back("format_print_str: .asciz \"%s\\n\"");
    output.push_back("format_print_int: .asciz \"%ld\\n\"");
    output.push_back("\nformat_print_true: .asciz \"True\\n\"");
    output.push_back("format_print_false: .asciz \"False\\n\"");

    output.push_back(".text\n.globl main\n");

    // obvious code at the top !!...

    for (int i = 0; i < arguments.size(); i++)
    {
        if (arguments[i] == "")
            continue;

        vector<string> words;
        words = parseStringIntoVector(arguments[i]);
        for (auto &j : words)
        {
            if (j == "True")
                j = "1";
            if (j == "False")
                j = "0";
        }

        if (returned && words[2] != "popparameter")
        {
            temp.push_back("movq %rbx, %rsp");
            temp.push_back("popq %rcx");
            temp.push_back("popq %r9");
            temp.push_back("popq %r8");
            temp.push_back("popq %rsi");
            temp.push_back("popq %rax");
            temp.push_back("popq %r11");
            temp.push_back("popq %r10");
            temp.push_back("popq %rdi");
            temp.push_back("popq %rdx");
            returned = 0;
        }

        if (words[1] == ":")
        {
            // cout<<"here --> "<<words[0]<<" , "<<words[1]<<"\n";
            if (words[0][0] == '.')
            {
                temp.push_back(words[0] + words[1]);
            }
            else
            {
                if (current_class != before_dot(words[0]))
                {
                    off_class = 0;
                    current_class = before_dot(words[0]);
                }
                curr_function = words[0];
                if (current_class != "" && words[2] != "")
                {
                    string child = current_class;
                    for (auto it : off_of_cls[words[2]])
                    {
                        off_of_cls[current_class][it.first] = it.second;
                        off_class += 8;
                    }
                }
                output.push_back(words[0] + ":");
            }

            continue;
        }

        if (words[0] == "call")
        {
            temp.push_back("call " + words[1]);
            continue;
        }

        if (words[0] == "funcend")
        {
            curr_function = "global";
            output.push_back("subq $" + to_string(-off_curr - 8) + ", %rsp");
            push_into_vector();
            output.push_back("leave");
            output.push_back("ret");
            off_curr = -8;
            off_parm = 16;
            continue;
        }

        if (words[0] == "funcbegin")
        {
            output.push_back("pushq %rbp");
            output.push_back("movq %rsp, %rbp");
            temp.clear();
            continue;
        }

        solve(words);
        if (words[2].size() >= 1 && before_dot(words[2]) == "self")
        {
            temp.push_back("movq " + off[curr_function]["self"] + ", %rcx");
            temp.push_back("movq $" + to_string(off_of_cls[current_class][after_dot(words[2])]) + ", %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq (%rcx), %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if (words[0].size() >= 1 && before_dot(words[0]) == "self")
        {
            temp.push_back("movq " + off[curr_function]["self"] + ", %rcx");
            temp.push_back("movq $" + to_string(off_of_cls[current_class][after_dot(words[0])]) + ", %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq %rdx, (%rcx)");
            continue;
        }

        if (words[2].size() && words[2][0] == '"')
        {
            temp.push_back(off[curr_function][words[2]]);
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }
        if (words[2] == "popparameter" && !returned)
        {
            temp.push_back("movq " + to_string(off_parm) + "(%rbp), %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            off_parm += 8;
            continue;
        }

        if (words[2] == "popparameter" && returned)
        {
            temp.push_back("movq %rax, " + off[curr_function][words[0]]);
            continue;
        }

        if ((words[0] == "return") && (words[1] != ""))
        {
            temp.push_back("movq " + off[curr_function][words[1]] + ", %rax");
            temp.push_back("leave");
            temp.push_back("ret");
            continue;
        }

        if (words[0] == "param")
        {
            if (!param)
            {
                temp.push_back("pushq %rdx");
                temp.push_back("pushq %rdi");
                temp.push_back("pushq %r10");
                temp.push_back("pushq %r11");
                temp.push_back("pushq %rax");
                temp.push_back("pushq %rsi");
                temp.push_back("pushq %r8");
                temp.push_back("pushq %r9");
                temp.push_back("pushq %rcx");
                temp.push_back("movq %rsp, %rbx");
                temp.push_back("movq %rsp, %rcx");
                temp.push_back("addq $-8, %rcx");
                temp.push_back("andq $15, %rcx");
                temp.push_back("subq %rcx, %rsp");
            }
            param = 1;
            temp.push_back("movq " + off[curr_function][words[1]] + ", %rdx");
            temp.push_back("pushq %rdx");
            continue;
        }

        if (words[0] == "stackpointer" && words[1][0] == '-')
        {
            // cout<<"came";
            returned = 1;
            param = 0;
            continue;
        }

        if (words[3] == "[]" && words[1] == "=")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rcx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rdx");
            temp.push_back("addq $1, %rdx");
            temp.push_back("imulq $8, %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq (%rcx), %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }
        if (words[1] == "[]" && words[3] == "=")
        {
            temp.push_back("movq " + off[curr_function][words[0]] + ", %rcx");
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("addq $1, %rdx");
            temp.push_back("imulq $8, %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rdx");
            temp.push_back("movq %rdx, (%rcx)");
            continue;
        }

        if (words[3] == "." && words[1] == "=")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rcx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq (%rcx), %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]] + "");
            continue;
        }
        if (words[1] == "." && words[3] == "=")
        {
            temp.push_back("movq " + off[curr_function][words[0]] + ", %rcx");
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("addq %rdx, %rcx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rdx");
            temp.push_back("movq %rdx, (%rcx)");
            continue;
        }
        if (words[0][0] == '*')
        {
            string y = "";
            for (int i = 2; i < words[0].length() - 1; i++)
            {
                y += words[0][i];
            }
            temp.push_back("movq " + off[curr_function][y] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rcx");
            temp.push_back("movq %rcx, (%rdx)");
            continue;
        }

        // main arthimetic here starts

        if (check_arith(words[3]) != "")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rbx");
            temp.push_back(check_arith(words[3]) + " %rbx, %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if (check_logical(words[2]) == "not")
        {
            temp.push_back("movq " + off[curr_function][words[3]] + ", %rdx");
            temp.push_back(check_logical(words[2]) + " %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if (check_logical(words[3]) != "")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rbx");
            temp.push_back(check_logical(words[3]) + " %rbx, %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if (words[3] == "%")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rax");
            temp.push_back("cdq");
            temp.push_back("idivq " + off[curr_function][words[4]]);
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if ((words[3] == "/") || (words[3] == "//"))
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rax");
            temp.push_back("cdq");
            temp.push_back("idivq " + off[curr_function][words[4]]);
            temp.push_back("movq %rax, " + off[curr_function][words[0]]);
            continue;
        }

        if (words[2] == "-")
        {
            temp.push_back("movq " + off[curr_function][words[3]] + ", %rbx");
            temp.push_back("movq $0, %rdx");
            temp.push_back("subq %rbx, %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }
        if (words[2] == "+")
        {
            temp.push_back("movq " + off[curr_function][words[3]] + ", %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
            continue;
        }

        if (check_rel(words[3]) != "")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rcx");
            temp.push_back("cmp %rcx, %rdx");
            temp.push_back("movq $0, %rcx");
            temp.push_back(check_rel(words[3]) + " %cl");
            temp.push_back("movq %rcx, " + off[curr_function][words[0]]);
        }

        if (words[0] == "if")
        {
            temp.push_back("movq " + off[curr_function][words[1]] + ", %rdx");
            temp.push_back("cmp $0, %rdx");
            temp.push_back("jg " + words[3]);
            continue;
        }

        if (words[0] == "jump")
        {
            temp.push_back("jmp " + words[1]);
            continue;
        }

        if (words[3] == ">>")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rcx");
            temp.push_back("sar %cl, %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
        }
        if (words[3] == "<<")
        {
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rcx");
            temp.push_back("sal %rcx, %rdx");
            temp.push_back("movq %rdx, " + off[curr_function][words[0]]);
        }
        // cout<<"here477";
        if ((words[1] == "=") && (words[3] == ""))
        {
            // cout<<"here480";
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rax");
            temp.push_back("movq %rax, " + off[curr_function][words[0]]);
            continue;
        }
        // cout<<"here485";

        if (words[3] == "**")
        {
            // a = b ** c , case:
            temp.push_back("pushq %rdx");
            temp.push_back("pushq %rdi");
            temp.push_back("pushq %r10");
            temp.push_back("pushq %r11");
            temp.push_back("pushq %rax");
            temp.push_back("pushq %rsi");
            temp.push_back("pushq %r8");
            temp.push_back("pushq %r9");
            temp.push_back("pushq %rcx");
            temp.push_back("movq %rsp, %rbx");
            temp.push_back("movq %rsp, %rcx");
            temp.push_back("addq $-8, %rcx");
            temp.push_back("andq $15, %rcx");
            temp.push_back("subq %rcx, %rsp");
            temp.push_back("movq " + off[curr_function][words[2]] + ", %rdx");
            temp.push_back("pushq %rdx");
            temp.push_back("movq " + off[curr_function][words[4]] + ", %rdx");
            temp.push_back("pushq %rdx");
            temp.push_back("call .power");
            temp.push_back("movq %rax, " + off[curr_function][words[0]]);
            temp.push_back("movq %rbx, %rsp");
            temp.push_back("popq %rcx");
            temp.push_back("popq %r9");
            temp.push_back("popq %r8");
            temp.push_back("popq %rsi");
            temp.push_back("popq %rax");
            temp.push_back("popq %r11");
            temp.push_back("popq %r10");
            temp.push_back("popq %rdi");
            temp.push_back("popq %rdx");
            continue;
        }
    }

    output.push_back("print_int:");
    output.push_back("pushq %rbp");
    output.push_back("movq %rsp, %rbp");
    output.push_back("movq 16(%rbp), %rsi");
    output.push_back("lea format_print_int(%rip), %rdi");
    output.push_back("xorq %rax, %rax");
    output.push_back("callq printf@plt");
    output.push_back("leave");
    output.push_back("ret");

    output.push_back("print_bool:");
    output.push_back("pushq %rbp");
    output.push_back("movq %rsp, %rbp");
    output.push_back("movq 16(%rbp), %rcx");
    output.push_back("cmp $0, %rcx");
    output.push_back("jne print_true_label");
    output.push_back("lea format_print_false(%rip), %rdi");
    output.push_back("jmp print_false_exit");
    output.push_back("print_true_label:");
    output.push_back("lea format_print_true(%rip), %rdi");
    output.push_back("print_false_exit:");
    output.push_back("xorq %rax, %rax");
    output.push_back("callq printf@plt");
    output.push_back("leave");
    output.push_back("ret");

    output.push_back("print_str:");
    output.push_back("pushq %rbp");
    output.push_back("movq %rsp, %rbp");
    output.push_back("movq 16(%rbp), %rsi");
    output.push_back("lea format_print_str(%rip), %rdi");
    output.push_back("xorq %rax, %rax");
    output.push_back("callq printf@plt");
    output.push_back("leave");
    output.push_back("ret");

    output.push_back("get_list:");
    output.push_back("pushq %rbp");
    output.push_back("movq %rsp, %rbp");
    output.push_back("movq 16(%rbp), %rdi");
    output.push_back("callq malloc");
    output.push_back("leave");
    output.push_back("ret");

    output.push_back(".power:");
    output.push_back("pushq %rbp");
    output.push_back("movq %rsp, %rbp");
    output.push_back("subq $-32, %rsp");
    output.push_back("movq $0, -24(%rbp)");
    output.push_back("movq $1, -32(%rbp)");
    output.push_back("jmp .L2");
    output.push_back(".L3:");
    output.push_back("movq -32(%rbp), %rax");
    output.push_back("imulq 16(%rbp), %rax");
    output.push_back("movq %rax, -32(%rbp)");
    output.push_back("addq $1, -24(%rbp)");
    output.push_back(".L2:");
    output.push_back("movq -24(%rbp), %rax");
    output.push_back("cmpq 24(%rbp), %rax");
    output.push_back("jl .L3");
    output.push_back("movq -32(%rbp), %rax");
    output.push_back("leave");
    output.push_back("ret");

    // string outputFilename;
    // outputFilename=argv[2];

    // // Open the output file
    // ofstream outputFile(outputFilename);

    // // Check if the output file is opened successfully
    // if (!outputFile.is_open()) {
    //     cerr << "Error: Unable to open output file " << outputFilename << endl;
    //     return 1;
    // }
    // Write the contents of the string to the output file

    // cout<<"*****************x86 starts here****************\n";
    // string ans="";
    for (int i = 0; i < output.size(); i++)
    {
        cout << output[i] << "\n";
        if (i == 4)
        {

            for (auto it : store_string)
            {
                string ttt = it.first + ": .asciz " + it.second;
                cout << ttt << "\n";
            }
        }
    }
    // for(int i=0;i<output.size();i++) cout << output[i]<< endl;
    // outputFile << ans;

    // Close the output file
    // outputFile.close();

    // cout<<"*****************x86 endsss here******************\n";

    return 0;
}