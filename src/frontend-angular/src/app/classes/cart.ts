import { CarCart } from "./car";

export interface CartRows {
    [key: string]: CarCart
}

export interface Cart {
    rows: CartRows,
    totalPrice: number,
    totalCount: number
}
