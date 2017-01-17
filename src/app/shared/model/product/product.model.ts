export class Product {
  product_id: number = 0;
  product_name: string = '';
  product_code: string = '';
  item_id: number = 0;
  private _total: number = 0;
  private _item_rate: number = 0;
  private _quantity: number = 0;

  public set quantity(newValue: number) {
    this._quantity = newValue;
    this.calculateTotal();
  }

  public get quantity(): number {
    return this._quantity;
  }

  public set item_rate(newValue: number) {
    this._item_rate = newValue;
    this.calculateTotal();
  }

  public get item_rate(): number {
    return this._item_rate;
  }

public set total(newValue: number){
  this._total = newValue;
  this.calculateRate();
}

public get total(): number{
return this._total;
}
 private calculateTotal(): void {
     this.total = this._item_rate * this._quantity;
  }
  private calculateRate(): void {
    if (this._total !== 0) {
      this._item_rate = this.total / this._quantity;
    }
   }
}

export class Item {
  items_id: number = 0;
  item: string = '';
  item_rate: string = '';
}
  // private onItemSelect(selectedItemId: number): void {
  //   this.selecteditem = this.itemArray.filter(function (item) {
  //     return item.items_id == selectedItemId;
  //   })[0];
  //    this.model.item_rate = parseInt(this.selecteditem.item_rate);
  // }
