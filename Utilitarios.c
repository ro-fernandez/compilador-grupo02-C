#include "Utilitarios.h"

void removeChar(char *s, char c)
{
    int i = 0, j = 0;

    while (s[j])
    {
        if (s[j]!=c) 
        {   
            s[i++] = s[j];
        }

        j++;       
    }

    s[i]=0;
}

void replaceChar(char *s, char c, char r)
{
    int i = 0, j = 0;

    while (s[j])
    {
        if (s[j]==c) 
        {   
            s[j] = r;
        }

        j++;       
    }
}