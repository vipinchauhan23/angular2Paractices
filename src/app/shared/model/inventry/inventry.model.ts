import {InventryDetail } from '../../../shared/model/inventory-detail/inventory-detail.model';
export class Inventry {
  inventry_id: number = 0;
  type: number = 0;
  name: string = '';
  address: string = '';
  mobile_no: string = '';
  tin_no: string = '';
  total: number = 0;
   inventryDetails: Array<InventryDetail>;
  constructor() {
      this.inventryDetails = new Array<InventryDetail>();
  }
}
//  private calculateTotal(): void {
//      this.total = this.item_rate * this.quantity;
//   }
//   private calculateRate(): void {
//     if (this.total !== 0) {
//       this.item_rate = this.total / this.quantity;
//     }
//    }


export class Item {
  items_id: number = 0;
  item: string = '';
  item_rate: string = '';
  stock: number = 0;
}
  // private onItemSelect(selectedItemId: number): void {
  //   this.selecteditem = this.itemArray.filter(function (item) {
  //     return item.items_id == selectedItemId;
  //   })[0];
  //    this.model.item_rate = parseInt(this.selecteditem.item_rate);
  // }
