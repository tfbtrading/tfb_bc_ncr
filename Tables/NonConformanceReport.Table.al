table 50801 "TFB Non-Conformance Report"
{
    DataClassification = CustomerContent;
    Caption = 'Non-Conformance Report';
    LookupPageId = "TFB Non Conformance Reports";
    Scope = Cloud;
    TableType = Normal;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()

            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    SalesReceivablesSetup.GET();
                    NoSeriesManagement.TestManual(SalesReceivablesSetup."TFB Non Conf. Report Nos.");
                    "No. Series" := '';
                    NoSeriesManagement.SetSeries("No.");

                END;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            ValidateTableRelation = true;

        }
        field(10; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                If Customer.Get("Customer No.") then begin
                    "Customer Name" := Customer.Name;
                    Validate("Contact No.", Customer."Primary Contact No.");
                end;
            end;
        }
        field(20; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate()

            var
                Customer: Record Customer;
            begin

                Validate("Customer No.", Customer.GetCustNo("Customer Name"));

            end;

        }
        field(22; "Vendor No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                VendorRec: Record Vendor;
            begin
                VendorRec.Get("Vendor No.");
                "Vendor Name" := VendorRec.Name;


            end;


        }
        field(24; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            ValidateTableRelation = False;

            trigger OnValidate()

            var
                VendorRec: Record Vendor;
            begin

                Validate("Vendor No.", VendorRec.GetVendorNo("Vendor Name"));


            end;

        }
        field(30; "External Reference No."; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(40; "Date Raised"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(45; "Contact No."; Code[20])
        {
            TableRelation = Contact;
            ValidateTableRelation = true;

            trigger OnLookup()

            var
                Contacts: Record Contact;
                Relation: Record "Contact Business Relation";
                ContactList: Page "Contact List";

            begin

                Contacts.SetRange("Company No.", Relation.GetContactNo(Relation."Link to Table"::Customer, "Customer No."));
                If Contacts.Count() > 0 then begin
                    ContactList.SetRecord(Contacts);
                    ContactList.SetTableView(Contacts);
                    ContactList.LookupMode := true;
                    If ContactList.RunModal() = Action::LookupOK then begin
                        ContactList.GetRecord(Contacts);
                        Validate("Contact No.", Contacts."No.");
                    end;

                end;
            end;

            trigger OnValidate()

            var
                Contact: Record Contact;

            begin

                If Contact.Get("Contact No.") then begin

                    "E-mail" := Contact."E-Mail";
                    "Issued By" := Contact.Name;
                end;

            end;

        }

        field(50; "Issued By"; Text[100])
        {
            DataClassification = CustomerContent;
        }

        field(60; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item;
            ValidateTableRelation = true;
            NotBlank = true;

            trigger OnValidate()

            var
                Item: record Item;

            begin
                If Item.Get("Item No.") then
                    Description := Item.Description;
            end;
        }

        field(65; "Variant"; Code[20])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            ValidateTableRelation = true;

            DataClassification = CustomerContent;
        }

        field(70; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(75; "Order Type"; Enum "TFB NCR Order Type")
        {
            DataClassification = CustomerContent;
            Editable = true;
        }

        field(80; "Lot No."; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = true;
            TableRelation = "Lot No. Information" where("Item No." = field("Item No."));
            ValidateTableRelation = false;

        }
        field(85; "Item Ledger Entry No."; Integer)
        {
            TableRelation = "Item Ledger Entry" where("Item No." = field("Item No."), "Entry Type" = const(Sale), "Source Type" = const(Customer), "Source No." = field("Customer No."));
            DataClassification = CustomerContent;
        }
        field(86; "Ledger Order No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Document No." where("Entry No." = field("Item Ledger Entry No.")));
        }
        field(87; "Ledger External Reference No."; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."External Document No." where("Entry No." = field("Item Ledger Entry No.")));
        }
        field(89; "Drop Shipment"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(90; "Type"; Enum "TFB NCR Type")
        {
            DataClassification = CustomerContent;
        }

        field(100; "E-mail"; text[100])
        {
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }

        field(110; "Corrective Action Due"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(115; "Date Closed"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(120; "Non-Conformity Details"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(122; "Questions"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(125; "Supporting Media"; MediaSet)
        {
            DataClassification = CustomerContent;
        }

        field(130; "Invest. and Root Cause"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(140; "Corrective Action"; Text[2048])
        {
            DataClassification = CustomerContent;
        }
        field(150; Status; Enum "TFB NCR Status")
        {
            DataClassification = CustomerContent;

            trigger OnValidate()

            begin
                case Status of
                    Status::Complete:
                        begin
                            Closed := true;
                            If "Date Closed" = 0D then
                                "Date Closed" := WorkDate();
                        end;
                    else begin
                            Closed := false;
                            "Date Closed" := 0D;
                        end;
                end;
            end;
        }
        field(152; "No. of Sales Cr"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Sales Cr.Memo Header" where("TFB NCR No." = field("No.")));

        }
        field(160; Closed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }



    }


    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer Name")
        {

        }
        Key(DataRaised; "Date Raised")
        {

        }
        Key(Status; Status)
        {

        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Order Type", "Customer Name", "Date Raised", Description, Type) { }

        fieldgroup(Brick; "No.", "Customer Name", "Date Raised", Description, Type) { }
    }

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";

        NoSeriesManagement: Codeunit NoSeriesManagement;

    trigger OnInsert()
    begin
        If "No." = '' then begin

            SalesReceivablesSetup.Get();
            SalesReceivablesSetup.TestField("TFB Non Conf. Report Nos.");
            NoSeriesManagement.InitSeries(SalesReceivablesSetup."TFB Non Conf. Report Nos.", Rec."No. Series", 0D, "No.", "No. Series");
        end;
    end;
}