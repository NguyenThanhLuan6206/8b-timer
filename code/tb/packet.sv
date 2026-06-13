class packet;
  typedef enum bit {READ=0 , WRITE=1} transfer_enum;
  rand bit [7:0]       addr;
  rand bit [7:0]       data;
  rand transfer_enum   transfer;

  bit [7:0]            prdata;
  bit                  int_signal;

  function new();
  endfunction

  function void display();
    $display("Addr: 0x%0h, Type: %s, Data: 0x%0h, RD: 0x%0h", addr, transfer.name(), data, prdata);
  endfunction
endclass
