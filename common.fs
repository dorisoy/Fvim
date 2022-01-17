module FVim.common

open System.Runtime.InteropServices
open System.Threading.Tasks

let mkparams1 (t1: 'T1)                                          = [| box t1 |]
let mkparams2 (t1: 'T1) (t2: 'T2)                                = [| box t1; box t2 |]
let mkparams3 (t1: 'T1) (t2: 'T2) (t3: 'T3)                      = [| box t1; box t2; box t3 |]
let mkparams4 (t1: 'T1) (t2: 'T2) (t3: 'T3) (t4: 'T4)            = [| box t1; box t2; box t3; box t4|]
let mkparams5 (t1: 'T1) (t2: 'T2) (t3: 'T3) (t4: 'T4) (t5: 'T5)  = [| box t1; box t2; box t3; box t4; box t5|]

let ParseUInt16 (x: string) =
    match System.UInt16.TryParse x with
    | true, x -> Some x
    | _ -> None

let (|ParseUInt16|_|) (x: string) =
    match System.UInt16.TryParse x with
    | true, x -> Some x
    | _ -> None

let (|ParseInt32|_|) (x: string) =
    match System.Int32.TryParse x with
    | true, x -> Some x
    | _ -> None

let (|ParseIp|_|) (x: string) =
    match System.Net.IPAddress.TryParse x with
    | true, x -> Some x
    | _ -> 
        try 
            System.Net.Dns.GetHostEntry(x).AddressList
            |> Seq.tryFind (fun addr -> addr.AddressFamily = System.Net.Sockets.AddressFamily.InterNetwork)
        with _ -> None

let (|ObjArray|_|) (x:obj) =
    match x with
    | :? (obj[]) as x    -> Some x
    | :? (obj list) as x -> Some(Array.ofList x)
    | :? (obj seq) as x  -> Some(Array.ofSeq x)
    | _                  -> None

let (|Bool|_|) (x:obj) =
    match x with
    | :? bool as x       -> Some x
    | _ -> None

let (|String|_|) (x:obj) =
    match x with
    | :? string as x     -> Some x
    | _ -> None

let IsString (x:obj) =
    match x with
    | :? string as x     -> Some x
    | _ -> None

let Integer32 (x:obj) =
    match x with
    | :? int32  as x     -> Some(int32 x)
    | :? int16  as x     -> Some(int32 x)
    | :? int8   as x     -> Some(int32 x)
    | :? uint16 as x     -> Some(int32 x)
    | :? uint32 as x     -> Some(int32 x)
    | :? uint8  as x     -> Some(int32 x)
    | _ -> None

let (|Integer32|_|) (x:obj) =
    match x with
    | :? int32  as x     -> Some(int32 x)
    | :? int16  as x     -> Some(int32 x)
    | :? int8   as x     -> Some(int32 x)
    | :? uint16 as x     -> Some(int32 x)
    | :? uint32 as x     -> Some(int32 x)
    | :? uint8  as x     -> Some(int32 x)
    | _ -> None

let (|Float|_|) (x:obj) =
    match x with
    | Integer32 x        -> Some(float x)
    | :? single as x     -> Some(float x)
    | :? float as x      -> Some(float x)
    | _ -> None

// converts to bool in a desperate (read: JavaScript) attempt
let (|ForceBool|_|) (x:obj) =
    match x with
    | Bool x -> Some x
    | String("v:true")
    | String("true") -> Some true
    | String("v:false") 
    | String("false") -> Some false
    | String(ParseInt32 x) when x <> 0 -> Some true
    | String(ParseInt32 x) when x = 0 -> Some false
    | String("") -> Some false
    | String(_) -> Some true
    | _ -> None


type hashmap<'a, 'b> = System.Collections.Generic.Dictionary<'a, 'b>
let hashmap (xs: seq<'a*'b>) = new hashmap<'a,'b>(xs |> Seq.map (fun (a,b) -> System.Collections.Generic.KeyValuePair(a,b)))

let escapeArgs: string seq -> string seq = Seq.map (fun (x: string) -> if x.Contains(' ') then sprintf "\"%s\"" (x.Replace("\"", "\\\"")) else x)
let join (xs: string seq) = System.String.Join(" ", xs)

let inline (>>=) (x: 'a option) (f: 'a -> 'b option) =
    match x with
    | Some x -> f x
    | _ -> None

let inline (>?=) (x: Result<'a, 'e>) (f: 'a -> Result<'b, 'e>) =
    match x with
    | Ok result -> f result
    | Error err -> Error err

let run (t: Task) =
    Task.Run(fun () -> t) |> ignore

let runSync (t: Task) =
    t.Wait()

[<AutoOpen>]
module internal helpers =
    let _d x = Option.defaultValue x

