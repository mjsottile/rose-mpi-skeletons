void f ()
{
  int i;
  for (i=0; i<5; i++) {
    #pragma skel remove
  }
  // #pragma skel remove
}

void g () {
  #pragma skel loop iterate exactly(10*10)
}

int main ()
{
  // #pragma skel loop iterate atmost(5)
  int x = 5;
  return x;
}
