export interface Car {
    car_id: string,
    price: number,
    name: string,
    description: string,
    brand: number,
    category: string,
    km: number,
    views: number,
    at: string,
    stock: number,
    favorite?: boolean,
}

export interface CarCart {
    qty: number,
    car: Car
}

export interface CarList {
    cars: Car[],
    pages: number
}
  
export interface CarSearch {
    text?: string,
    categories: string[],
    min_price: number,
    max_price: number,
    max_km?: number,
    sort?: string,
    published?: string,
    brand?: string,
    page?: number
}