import { Component, OnInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { Router } from '@angular/router';
import { DataService } from '../../services/data.service';
import { ToastrService } from 'ngx-toastr';
import { ModuleConfig } from '../../module.config';
import { MatStepper } from '@angular/material';
import { FormGroup } from '@angular/forms';
import { StepsService } from './steps.service';

@Component({
	selector: 'pnx-import-process',
	styleUrls: [ 'import-process.component.scss' ],
	templateUrl: 'import-process.component.html'
})
export class ImportProcessComponent implements OnInit {

	public step1Control: FormGroup;
    public step2Control: FormGroup;
    public step3Control: FormGroup;

	public srid: any;
	public columns;
	public IMPORT_CONFIG = ModuleConfig;

    contentMappingInfo: any;
    table_name: any;
    selected_columns: any;
    added_columns: any;
    importId: any;
	
	@ViewChild('stepper') stepper: MatStepper;
	
	constructor(
		private _router: Router,
		private _ds: DataService,
		private toastr: ToastrService,
		private stepService: StepsService,
		private cd: ChangeDetectorRef
	) {}

	ngOnInit() {}

	ngAfterViewInit() {
		this.stepService.getStep().subscribe((step) => {
			if (step) {
				if (step.stepForm && step.type === 'next') {
					switch (step.id) {
						case 'one': {
							this.step1Control = step.stepForm;
                            this.importId = step.data.importId;
                            console.log(this.importId);
							this.srid = step.data.srid;
							this.columns = step.data.columns.map((col) => {
								return {
									id: col,
									selected: false
								};
							});
							this.cd.detectChanges();
							break;
						}
						case 'two': {
							this.step2Control = step.stepForm;
                            this.contentMappingInfo = step.data.content_mapping_info;
                            this.table_name = step.data.table_name;
                            this.selected_columns = step.data.selected_columns;
                            this.added_columns = step.data.added_columns;
							this.cd.detectChanges();
							break;
                        }
                        case 'three': {
                            this.step3Control = step.stepForm;
                            this.cd.detectChanges();
							break;
                        }
					}
					this.stepper.next();
				}
				if (step.type === 'previous') {
					this.stepper.previous();
				}
			}
		});
	}


	cancelImport() {
		this._ds.cancelImport(this.importId).subscribe(
			() => {
				this._router.navigate([ `${this.IMPORT_CONFIG.MODULE_URL}` ]);
			},
			(error) => {
				if (error.statusText === 'Unknown Error') {
					// show error message if no connexion
					this.toastr.error('ERROR: IMPOSSIBLE TO CONNECT TO SERVER (check your connexion)');
				} else {
					if (error.status = 400) {
						this._router.navigate([ `${this.IMPORT_CONFIG.MODULE_URL}` ]);
					}
					// show error message if other server error
					this.toastr.error(error.error.message);
				}
			}
		);
	}

	onImportList() {
		this._router.navigate([ `${this.IMPORT_CONFIG.MODULE_URL}` ]);
	}
}
